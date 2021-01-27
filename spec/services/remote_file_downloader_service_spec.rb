# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RemoteFileDownloaderService do
  subject(:result) { described_class.call(url) }

  let(:url) { 'https://example.com/' }
  let(:uri_stub) { URI(url) }
  let(:download_stub) { nil }

  before do
    allow(URI).to receive(:parse).with(url).and_return(uri_stub)
    allow(uri_stub).to receive(:open).and_return(download_stub)
  end

  it { expect(result).to be_nil }

  context 'when tempfile downloaded' do
    let(:download_stub) { StringIO.new("StringIO\ncontent") }

    it :aggregate_failures do
      expect(result).to be_a(Tempfile)
      expect(result.read).to eq("StringIO\ncontent")
    end
  end

  context 'when StringIO downloaded' do
    let(:download_stub) do
      file = Tempfile.new(mode: mode)
      file.write("Tempfile\ncontent")
      file.flush
    end
    let(:mode) { File::RDWR | File::BINARY }

    it :aggregate_failures do
      expect(result).to be_a(Tempfile)
      expect(result.read).to eq("Tempfile\ncontent")
    end

    context 'when non-binary file' do
      let(:mode) { File::RDWR }

      it :aggregate_failures do
        expect(result).to be_a(Tempfile)
        expect(result.read).to eq("Tempfile\ncontent")
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormatConverterService do
  subject(:result) { described_class.call(io, initial_format, format, *args, **opts) }

  let(:io) { nil }
  let(:initial_format) { nil }
  let(:format) { nil }
  let(:args) { [] }
  let(:opts) { {} }

  it { expect(result).to be_nil }

  context 'when formats and data specified' do
    let(:io) { StringIO.new(data) }
    let(:data) { 'data' }
    let(:initial_format) { :m3u8url }
    let(:format) { :dca }

    before do
      allow(described_class).to receive(:spawn).and_return(42)
      allow(Process).to receive(:wait).with(42)
    end

    it { expect(result).to be_a(Tempfile) }

    context 'when formats matching' do
      let(:format) { initial_format }

      it { expect(result).to be(io) }
    end

    context 'when m3u8url -> mp3' do
      let(:initial_format) { :m3u8url }
      let(:format) { :mp3 }

      it { expect(result).to be_a(Tempfile) }
    end

    context 'when mp3 -> dca' do
      let(:initial_format) { :mp3 }
      let(:format) { :dca }

      it { expect(result).to be_a(Tempfile) }
    end

    context 'when mp3 -> m3u8url' do
      let(:initial_format) { :mp3 }
      let(:format) { :m3u8url }

      it { expect(result).to be_nil }
    end
  end
end

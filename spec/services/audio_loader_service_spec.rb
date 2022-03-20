# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioLoaderService do
  subject(:result) { described_class.call({ manager:, id:, format: }) }

  let(:manager) { nil }
  let(:id) { nil }
  let(:format) { nil }

  it { expect(result).to be_nil }

  context 'when vk manager' do
    let(:manager) { :vk }

    before do
      stub_const('VK_AUDIO_MANAGER', instance_double(Vk::AudioManager))
      allow(VK_AUDIO_MANAGER).to receive(:url).and_return('url_stub')
    end

    it { expect(result).to be_nil }

    context 'when id present' do
      let(:id) { '1_0_a_b' }
      let(:expected_requested_format) { :m3u8url }

      before do
        allow(StringIO).to receive(:new).with('url_stub').and_return('io_stub')
        allow(FormatConverterService).to receive(:call).with('io_stub', :m3u8url, expected_requested_format)
                                                       .and_return('converted_io_stub')
      end

      it { expect(result).to eq('converted_io_stub') }

      context 'when requested format is empty string' do
        let(:format) { '' }
        let(:expected_requested_format) { :m3u8url }

        it { expect(result).to eq('converted_io_stub') }
      end

      context 'when requested format is correct' do
        let(:format) { 'mp3' }
        let(:expected_requested_format) { :mp3 }

        it { expect(result).to eq('converted_io_stub') }
      end
    end
  end
end

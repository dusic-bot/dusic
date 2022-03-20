# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudiosFetcherService do
  subject(:result) { described_class.call({ manager:, type:, query: }) }

  let(:manager) { nil }
  let(:type) { 'type_stub' }
  let(:query) { 'query_stub' }

  it :aggregate_failures do
    expect(result).to be_a(AudioResponse)
    expect(result).to be_empty
  end

  context 'when vk manager' do
    let(:manager) { :vk }

    it do
      stub_const('VK_AUDIO_MANAGER', instance_double(Vk::AudioManager))
      expect(VK_AUDIO_MANAGER).to receive(:request).with(:type_stub, 'query_stub')
      result
    end
  end
end

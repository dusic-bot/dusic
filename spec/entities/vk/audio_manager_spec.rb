# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vk::AudioManager do
  subject(:instance) { described_class.new('login', 'password') }

  let(:vk_client) { instance_double(VkMusic::Client) }

  before do
    allow(VkMusic::Client).to receive(:new).with(login: 'login', password: 'password').and_return(vk_client)
  end

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end

  describe '#request' do
    subject(:result) { instance.request(type, query) }

    let(:type) { nil }
    let(:query) { nil }
    let(:vkmusic_audio_stub) { VkMusic::Audio.new }
    let(:vkmusic_playlist_stub) { VkMusic::Playlist.new([vkmusic_audio_stub], id: 1, owner_id: 1, access_hash: 'a') }

    it :aggregate_failures do
      expect(result).to be_a(AudioResponse)
      expect(result).to be_empty
    end

    context 'when unknown type' do
      let(:type) { :sample_text }

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result).to be_empty
      end
    end

    context 'when auto' do
      let(:type) { :auto }
      let(:request_type_stub) { :find }
      let(:response_stub) { [vkmusic_audio_stub] }

      before do
        allow(VkMusic::Utility::DataTypeGuesser).to receive(:call).with(query).and_return(request_type_stub)
        allow(vk_client).to receive(:find).with(query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(request_type_stub)
        expect(result.response).to eq(response_stub)
      end
    end

    context 'when find' do
      let(:type) { :find }
      let(:response_stub) { [vkmusic_audio_stub] }

      before do
        allow(vk_client).to receive(:find).with(query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq(response_stub)
      end
    end

    context 'when playlist' do
      let(:type) { :playlist }
      let(:response_stub) { vkmusic_playlist_stub }

      before do
        allow(vk_client).to receive(:playlist).with(url: query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([response_stub])
      end
    end

    context 'when audios' do
      let(:type) { :audios }
      let(:response_stub) { vkmusic_playlist_stub }

      before do
        allow(vk_client).to receive(:audios).with(url: query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([response_stub])
      end
    end

    context 'when wall' do
      let(:type) { :wall }
      let(:response_stub) { vkmusic_playlist_stub }

      before do
        allow(vk_client).to receive(:wall).with(url: query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([response_stub])
      end
    end

    context 'when post' do
      let(:type) { :post }
      let(:response_stub) { [vkmusic_audio_stub] }

      before do
        allow(vk_client).to receive(:post).with(url: query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq(response_stub)
      end
    end

    context 'when artist' do
      let(:type) { :artist }
      let(:response_stub) { [vkmusic_audio_stub] }

      before do
        allow(vk_client).to receive(:artist).with(url: query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq(response_stub)
      end
    end

    context 'when nil return' do
      let(:type) { :find }
      let(:response_stub) { nil }

      before do
        allow(vk_client).to receive(:find).with(query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([])
      end
    end

    context 'when unknown return' do
      let(:type) { :find }
      let(:response_stub) { ['string'] }

      before do
        allow(vk_client).to receive(:find).with(query).and_return(response_stub)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([])
      end
    end

    context 'when error raised' do
      let(:type) { :find }
      let(:response_stub) { [vkmusic_audio_stub] }

      before do
        allow(vk_client).to receive(:find).with(query).and_raise(StandardError)
      end

      it :aggregate_failures do
        expect(result).to be_a(AudioResponse)
        expect(result.request_type).to eq(type)
        expect(result.response).to eq([])
      end
    end
  end
end

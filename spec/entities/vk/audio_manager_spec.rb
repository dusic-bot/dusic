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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_audio_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_audio_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_playlist_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_playlist_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_playlist_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_audio_stub)
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
        expect(result.response).to be_a(Array)
        expect(result.response.size).to eq(1)
        expect(result.response.first.external).to be(vkmusic_audio_stub)
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

  describe '#url' do
    subject(:result) { instance.url(audio) }

    let(:audio) { build(:vk_audio, external:, id:) }
    let(:external) { nil }
    let(:id) { nil }

    it { expect(result).to be_nil }

    context 'when with id' do
      let(:id) { '1_0_a_b' }
      let(:vk_audio_with_url) { VkMusic::Audio.new(url: 'url_from_remote') }

      before do
        allow(vk_client).to receive(:get_urls).with(['1_0_a_b']).and_return([vk_audio_with_url])
      end

      it { expect(result).to eq('url_from_remote') }
    end

    context 'when with external audio' do
      let(:external) { VkMusic::Audio.new(**vk_audio_data) }
      let(:vk_audio_data) { {} }

      it { expect(result).to be_nil }

      context 'when it have cached decoded url' do
        let(:vk_audio_data) { { url: 'url' } }

        it { expect(result).to eq('url') }
      end

      context 'when it have cached encoded url' do
        let(:vk_audio_data) { { url_encoded: 'url_encoded', url: nil, client_id: 42 } }

        before do
          allow(VkMusic::Utility::LinkDecoder).to receive(:call).with('url_encoded', 42).and_return('decoded_url')
        end

        it { expect(result).to eq('decoded_url') }
      end

      context 'when it have cached id' do
        let(:vk_audio_data) { { id: 0, owner_id: 1, secret1: 'a', secret2: 'b' } }
        let(:vk_audio_with_url) { VkMusic::Audio.new(url: 'url_from_remote') }

        before do
          allow(vk_client).to receive(:get_urls).with(['1_0_a_b']).and_return([vk_audio_with_url])
        end

        it { expect(result).to eq('url_from_remote') }

        context 'when requesting second time' do
          let(:second_result) { instance.url(audio) }

          it :aggregate_failures do
            expect(vk_client).to receive(:get_urls)
            expect(result).to eq('url_from_remote')
            expect(vk_client).not_to receive(:get_urls)
            expect(second_result).to eq('url_from_remote')
          end
        end
      end

      context 'when url fetch error' do
        let(:vk_audio_data) { { id: 0, owner_id: 1, secret1: 'a', secret2: 'b' } }

        before do
          allow(vk_client).to receive(:get_urls).with(['1_0_a_b']).and_raise(RuntimeError)
        end

        it { expect(result).to be_nil }
      end
    end
  end
end

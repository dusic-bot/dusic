# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioResponseBlueprint do
  subject(:result) { JSON.parse(described_class.render(audio_response)) }

  let(:audio_response) { build(:audio_response, request_type: request_type, response: response_items) }
  let(:request_type) { 'type' }
  let(:response_items) { [] }

  let(:expected_json) do
    {
      'request_type' => 'type',
      'response' => expected_response_json
    }
  end
  let(:expected_response_json) { [] }

  it { expect(result).to eq(expected_json) }

  context 'when empty response' do
    let(:audio_response) { AudioResponse.empty }

    let(:expected_json) do
      { 'request_type' => nil, 'response' => nil }
    end

    it { expect(result).to eq(expected_json) }
  end

  context 'when response_items contain Audio' do
    let(:response_items) do
      [
        build(:vk_audio, :with_vk_music_external, id: '1_0_a_b', duration: 42)
      ]
    end

    let(:expected_response_json) do
      [
        {
          'id' => '1_0_a_b',
          'manager' => 'vk',
          'artist' => 'artist',
          'title' => 'title',
          'duration' => 42
        }
      ]
    end

    it { expect(result).to eq(expected_json) }
  end

  context 'when response_items contain Playlist' do
    let(:response_items) do
      [
        build(
          :vk_playlist, :with_vk_music_external,
          id: '1_0_a', title: 'title', subtitle: 'subtitle',
          audios: [
            build(:vk_audio, :with_vk_music_external, id: '1_0_a_b', duration: 42),
            build(:vk_audio, :with_vk_music_external, id: '1_1_a_b', duration: 600)
          ]
        )
      ]
    end

    let(:expected_response_json) do
      [
        {
          'id' => '1_0_a',
          'manager' => 'vk',
          'title' => 'title - subtitle',
          'audios' => [
            {
              'id' => '1_0_a_b',
              'manager' => 'vk',
              'artist' => 'artist',
              'title' => 'title',
              'duration' => 42
            },
            {
              'id' => '1_1_a_b',
              'manager' => 'vk',
              'artist' => 'artist',
              'title' => 'title',
              'duration' => 600
            }
          ]
        }
      ]
    end

    it { expect(result).to eq(expected_json) }
  end

  context 'when both Audio and Playlist' do
    let(:response_items) do
      [
        build(:vk_audio, :with_vk_music_external, id: '1_1_a_b', duration: 600),
        build(
          :vk_playlist, :with_vk_music_external,
          id: '1_0_a', title: 'title', subtitle: 'subtitle',
          audios: [build(:vk_audio, :with_vk_music_external, id: '1_0_a_b', duration: 42)]
        )
      ]
    end

    let(:expected_response_json) do
      [
        {
          'id' => '1_1_a_b',
          'manager' => 'vk',
          'artist' => 'artist',
          'title' => 'title',
          'duration' => 600
        },
        {
          'id' => '1_0_a',
          'manager' => 'vk',
          'title' => 'title - subtitle',
          'audios' => [
            {
              'id' => '1_0_a_b',
              'manager' => 'vk',
              'artist' => 'artist',
              'title' => 'title',
              'duration' => 42
            }
          ]
        }
      ]
    end

    it { expect(result).to eq(expected_json) }
  end
end

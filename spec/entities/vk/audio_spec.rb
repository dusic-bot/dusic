# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vk::Audio do
  subject(:instance) { build(:vk_audio, external: external, id: id) }

  let(:external) { VkMusic::Audio.new(artist: 'artist', title: 'title', duration: 60) }
  let(:id) { 'id' }

  describe '#artist' do
    subject(:result) { instance.artist }

    it { expect(result).to eq('artist') }
  end

  describe '#title' do
    subject(:result) { instance.title }

    it { expect(result).to eq('title') }
  end

  describe '#duration' do
    subject(:result) { instance.duration }

    it { expect(result).to eq(60) }
  end

  describe '#duration_str' do
    subject(:result) { instance.duration_str }

    it { expect(result).to eq('00:01:00') }
  end
end

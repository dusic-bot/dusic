# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vk::Playlist do
  subject(:instance) { build(:vk_playlist, external:, id:, audios:) }

  let(:external) { VkMusic::Playlist.new(audios, title:, subtitle:) }
  let(:title) { 'title' }
  let(:subtitle) { 'subtitle' }
  let(:id) { 'id' }
  let(:audios) { [] }

  describe '#title' do
    subject(:result) { instance.title }

    it { expect(result).to eq('title - subtitle') }

    context 'when subtitle is blank' do
      let(:subtitle) { '' }

      it { expect(result).to eq('title') }
    end
  end
end

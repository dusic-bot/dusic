# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist do
  subject(:instance) { build(:playlist, external:, id:, audios:) }

  let(:external) { { stub: true } }
  let(:id) { 'id' }
  let(:audios) { [] }

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end

  describe '#external' do
    subject(:result) { instance.external }

    it { expect(result).to be(external) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    it { expect(result).to be(id) }
  end

  describe '#audios' do
    subject(:result) { instance.audios }

    it { expect(result).to be(audios) }
  end

  describe '#title' do
    subject(:result) { instance.title }

    it { expect { result }.to raise_error(NotImplementedError) }
  end

  describe '#size' do
    subject(:result) { instance.size }

    it { expect(result).to be(0) }

    context 'when with not empty audios array' do
      let(:audios) { [1, 2, 3] }

      it { expect(result).to be(3) }
    end
  end
end

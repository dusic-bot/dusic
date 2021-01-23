# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist do
  subject(:instance) { build(:playlist, external: external, id: id, audios: audios) }

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
end

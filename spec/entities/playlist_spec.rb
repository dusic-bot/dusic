# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Playlist do
  subject(:instance) { described_class.new(external, manager, id, audios) }

  let(:external) { { stub: true } }
  let(:manager) { :vk }
  let(:id) { 'id' }
  let(:audios) { [] }

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end

  describe '#external' do
    subject(:result) { instance.external }

    it { expect(result).to be(external) }
  end

  describe '#manager' do
    subject(:result) { instance.manager }

    it { expect(result).to be(manager) }
  end

  describe '#id' do
    subject(:result) { instance.id }

    it { expect(result).to be(id) }
  end

  describe '#audios' do
    subject(:result) { instance.audios }

    it { expect(result).to be(audios) }
  end

  describe 'delegation' do
    it 'delegates to external' do
      expect(instance[:stub]).to be(true)
    end
  end
end

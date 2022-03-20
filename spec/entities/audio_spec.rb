# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audio do
  subject(:instance) { build(:audio, external:, id:) }

  let(:external) { { stub: true } }
  let(:id) { 'id' }

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

  describe '#artist' do
    subject(:result) { instance.artist }

    it { expect { result }.to raise_error(NotImplementedError) }
  end

  describe '#title' do
    subject(:result) { instance.title }

    it { expect { result }.to raise_error(NotImplementedError) }
  end

  describe '#duration' do
    subject(:result) { instance.duration }

    it { expect { result }.to raise_error(NotImplementedError) }
  end

  describe '#duration_str' do
    subject(:result) { instance.duration_str }

    it { expect { result }.to raise_error(NotImplementedError) }
  end
end

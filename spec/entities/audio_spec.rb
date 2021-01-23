# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audio do
  subject(:instance) { build(:audio, external: external, id: id) }

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
end

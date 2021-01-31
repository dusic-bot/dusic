# frozen_string_literal: true

require 'rails_helper'
require 'alphabet_encoding'

RSpec.describe AlphabetEncoding do
  describe '.encode' do
    subject(:result) { described_class.encode(argument) }

    let(:argument) { 619808296743862300 }

    it { expect(result).to eq('WlBIoaqWXoe') }

    context 'when argument is a string' do
      let(:argument) { '619808296743862300' }

      it { expect(result).to eq('WlBIoaqWXoe') }
    end
  end

  describe '.decode' do
    subject(:result) { described_class.decode(argument) }

    let(:argument) { 'WlBIoaqWXoe' }

    it { expect(result).to eq(619808296743862300) }
  end
end

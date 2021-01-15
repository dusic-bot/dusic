# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationIdDecoderService do
  subject(:result) { described_class.call('fRydUVZYSwb_svRNDhRVJSe') }

  it :aggregate_failures do
    expect(AlphabetEncoding).to receive(:decode).with('fRydUVZYSwb').and_call_original
    expect(AlphabetEncoding).to receive(:decode).with('svRNDhRVJSe').and_call_original
    expect(result).to eq([208117693537058817, 702456545560100934])
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationIdDataFillerService do
  subject(:result) { described_class.call({ id:, user_id:, server_id: }) }

  let(:id) { nil }
  let(:user_id) { nil }
  let(:server_id) { nil }

  it { expect(result).to eq([nil, nil, nil]) }

  context 'when id specified' do
    let(:id) { 'fRydUVZYSwb_svRNDhRVJSe' }

    it { expect(result).to eq([id, 208117693537058817, 702456545560100934]) }
  end

  context 'when user_id specified' do
    let(:user_id) { 208117693537058817 }

    it { expect(result).to eq([nil, nil, nil]) }

    context 'when server_id specified' do
      let(:server_id) { 702456545560100934 }

      it { expect(result).to eq(['fRydUVZYSwb_svRNDhRVJSe', 208117693537058817, 702456545560100934]) }
    end
  end
end

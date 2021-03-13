# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationCreatorService do
  subject(:result) { described_class.call(10, date, message) }

  let(:date) { Time.current }
  let(:message) { '' }

  it :aggregate_failures do
    expect(result).to be_a(Donation)
    expect(result.size).to eq(10)
    expect(result.date).to eq(date)
    expect(result.discord_server_id).to be_nil
    expect(result.discord_user_id).to be_nil
  end

  context 'when donation id is present' do
    let(:message) { 'fRydUVZYSwb_svRNDhRVJSe' }

    it :aggregate_failures do
      expect(result).to be_a(Donation)
      expect(result.size).to eq(10)
      expect(result.date).to eq(date)
      expect(result.discord_server.external_id).to eq(702456545560100934)
      expect(result.discord_user.external_id).to eq(208117693537058817)
    end
  end

  context 'when big identifier' do
    let(:message) { 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA_svRNDhRVJSe' }

    it :aggregate_failures do
      expect(result).to be_a(Donation)
      expect(result.size).to eq(10)
      expect(result.date).to eq(date)
      expect(result.discord_server_id).to be_nil
      expect(result.discord_user_id).to be_nil
    end
  end
end

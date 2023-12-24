# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationCreatorService do
  subject(:result) { described_class.call(20, date, message, previous_donations_query:) }

  let(:date) { Time.current }
  let(:message) { '' }
  let(:previous_donations_query) { nil }

  it :aggregate_failures do
    expect(result).to be_a(Donation)
    expect(result.size).to eq(20)
    expect(result.date).to eq(date)
    expect(result.discord_server_id).to be_nil
    expect(result.discord_user_id).to be_nil
  end

  context 'when donation id is present' do
    let(:message) { 'fRydUVZYSwb_svRNDhRVJSe' }

    it :aggregate_failures do
      expect(result).to be_a(Donation)
      expect(result.size).to eq(20)
      expect(result.date).to eq(date)
      expect(result.discord_server.external_id).to eq(702456545560100934)
      expect(result.discord_user.external_id).to eq(208117693537058817)
    end

    context 'when server and user are already present' do
      let(:discord_server) { create(:discord_server, external_id: 702456545560100934) }
      let(:discord_user) { create(:discord_user, external_id: 208117693537058817) }

      before do
        discord_server
        discord_user
      end

      it :aggregate_failures do
        expect(result).to be_a(Donation)
        expect(result.size).to eq(20)
        expect(result.date).to eq(date)
        expect(result.discord_server).to eq(discord_server)
        expect(result.discord_user).to eq(discord_user)
      end
    end

    context 'when previous donation exist' do
      let(:previous_donation) { create(:donation) }
      let(:previous_donations_query) { Donation.where(id: [previous_donation.id]) }

      before { previous_donation }

      it 'does not use previous donation server and user', :aggregate_failures do
        expect(result.discord_server).not_to eq(previous_donation.discord_server)
        expect(result.discord_user).not_to eq(previous_donation.discord_user)
      end
    end
  end

  context 'when big identifier' do
    let(:message) { 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA_svRNDhRVJSe' }

    it :aggregate_failures do
      expect(result).to be_a(Donation)
      expect(result.size).to eq(20)
      expect(result.date).to eq(date)
      expect(result.discord_server_id).to be_nil
      expect(result.discord_user_id).to be_nil
    end

    context 'when previous donation exist' do
      let(:previous_donation) { create(:donation) }
      let(:previous_donations_query) { Donation.where(id: [previous_donation.id]) }

      before { previous_donation }

      it 'finds last donation in the query with both server and user', :aggregate_failures do
        expect(result).to be_a(Donation)
        expect(result.size).to eq(20)
        expect(result.date).to eq(date)
        expect(result.discord_server).to eq(previous_donation.discord_server)
        expect(result.discord_user).to eq(previous_donation.discord_user)
      end
    end
  end

  context 'when previous donations exist' do
    let(:donations) do
      [
        create(:donation),
        create(:donation, discord_server: nil, discord_user: nil),
        create(:donation),
        create(:donation, discord_server: nil, discord_user: nil)
      ]
    end
    let(:previous_donations_query) { Donation.where(id: [donations[0].id, donations[1].id, donations[2].id]) }

    before do
      donations
    end

    it 'finds last donation in the query with both server and user', :aggregate_failures do
      expect(result).to be_a(Donation)
      expect(result.size).to eq(20)
      expect(result.date).to eq(date)
      expect(result.discord_server).to eq(donations[2].discord_server)
      expect(result.discord_user).to eq(donations[2].discord_user)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkponchikDonationCreatorService do
  subject(:result) { described_class.call(data) }

  let(:data) { {} }

  it { expect(result).to be_nil }

  context 'when data present' do
    let(:data) { { 'id' => '1', 'date' => '1610498453676', 'amount' => '1', 'user' => '157230821', 'msg' => message } }
    let(:message) { nil }

    it :aggregate_failures do
      expect(result).to be_a(VkponchikDonation)
      expect(result.message).to be_nil
      expect(result.vk_user_external_id).to eq(157230821)
      expect(result.external_id).to eq(1)
      expect(result.donation).to be_a(Donation)
      expect(result.donation.size).to eq(1)
      expect(result.donation.date).to eq(Time.utc(2021, 1, 13, 0, 40, 53))
      expect(result.donation.discord_server).to be_nil
      expect(result.donation.discord_user).to be_nil
    end

    context 'when no message' do
      let(:data) { { 'id' => '1', 'date' => '1610498453676', 'amount' => '1', 'user' => '157230821' } }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.message).to be_nil
      end
    end

    context 'when message is empty string' do
      let(:message) { '' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.message).to eq('')
      end
    end

    context 'when message is gibberish' do
      let(:message) { 'Some random text lol' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.message).to eq('Some random text lol')
      end
    end

    context 'when message starts with donation identifier' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe. test' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains donation identifier' do
      let(:message) { 'test fRydUVZYSwb_svRNDhRVJSe test' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains 2 donation identifiers' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe test svRNDhRVJSe_fRydUVZYSwb' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains 2 same donation identifiers' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe test fRydUVZYSwb_svRNDhRVJSe' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when big identifier' do
      let(:message) { 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA_svRNDhRVJSe' }

      it :aggregate_failures do
        expect(result).to be_a(VkponchikDonation)
        expect(result.donation.discord_server).to be_nil
        expect(result.donation.discord_user).to be_nil
      end
    end
  end

  context 'when gibberish in data' do
    let(:data) { { 'error' => 'yes' } }

    it { expect(result).to be_nil }
  end
end

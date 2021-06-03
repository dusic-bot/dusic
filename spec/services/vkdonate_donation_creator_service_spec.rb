# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkdonateDonationCreatorService do
  subject(:result) { described_class.call(data) }

  let(:data) { nil }

  it { expect(result).to be_nil }

  context 'when data present' do
    let(:data) do
      Vkdonate::Donate.new(id: 1, uid: 157230821, date: date, sum: 1, msg: message, anon: false, visible: true)
    end
    let(:date) { DateTime.parse('2020-12-15 12:30:42 UTC+3') }
    let(:message) { nil }

    it :aggregate_failures do
      expect(result).to be_a(VkdonateDonation)
      expect(result.message).to be_nil
      expect(result.vk_user_external_id).to eq(157230821)
      expect(result.external_id).to eq(1)
      expect(result.donation).to be_a(Donation)
      expect(result.donation.size).to eq(1)
      expect(result.donation.date).to eq(Time.utc(2020, 12, 15, 9, 30, 42))
      expect(result.donation.discord_server).to be_nil
      expect(result.donation.discord_user).to be_nil
    end

    context 'when no message' do
      let(:message) { nil }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.message).to be_nil
      end
    end

    context 'when message is empty string' do
      let(:message) { '' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.message).to eq('')
      end
    end

    context 'when message is gibberish' do
      let(:message) { 'Some random text lol' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.message).to eq('Some random text lol')
      end
    end

    context 'when message starts with donation identifier' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe. test' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains donation identifier' do
      let(:message) { 'test fRydUVZYSwb_svRNDhRVJSe test' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains 2 donation identifiers' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe test svRNDhRVJSe_fRydUVZYSwb' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when message contains 2 same donation identifiers' do
      let(:message) { 'fRydUVZYSwb_svRNDhRVJSe test fRydUVZYSwb_svRNDhRVJSe' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server.external_id).to eq(702456545560100934)
        expect(result.donation.discord_user.external_id).to eq(208117693537058817)
      end
    end

    context 'when big identifier' do
      let(:message) { 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA_svRNDhRVJSe' }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server).to be_nil
        expect(result.donation.discord_user).to be_nil
      end
    end
  end

  context 'when gibberish in data' do
    let(:data) { { 'error' => 'yes' } }

    it { expect(result).to be_nil }
  end

  context 'when previously donated' do
    let(:previous_donation) do
      create(:donation, discord_server: create(:discord_server), discord_user: create(:discord_user))
    end
    let(:previous_vk_donation) do
      create(:vkdonate_donation, vk_user_external_id: 157230821, donation: previous_donation)
    end

    before { previous_vk_donation }

    it { expect(result).to be_nil }

    context 'when data provided' do
      let(:data) do
        Vkdonate::Donate.new(id: 1, uid: 157230821, date: date, sum: 1, msg: message, anon: false, visible: true)
      end
      let(:date) { DateTime.parse('2020-12-15 12:30:42 UTC+3') }
      let(:message) { nil }

      it :aggregate_failures do
        expect(result).to be_a(VkdonateDonation)
        expect(result.donation.discord_server).to eq(previous_donation.discord_server)
        expect(result.donation.discord_user).to eq(previous_donation.discord_user)
      end

      context 'when new identifier provided' do
        let(:message) { 'fRydUVZYSwb_svRNDhRVJSe' }

        it :aggregate_failures do
          expect(result).to be_a(VkdonateDonation)
          expect(result.donation.discord_server.external_id).to eq(702456545560100934)
          expect(result.donation.discord_user.external_id).to eq(208117693537058817)
        end
      end
    end
  end
end

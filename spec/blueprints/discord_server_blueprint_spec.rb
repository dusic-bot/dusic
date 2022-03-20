# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordServerBlueprint do
  subject(:result) { JSON.parse(described_class.render(discord_server)) }

  let(:discord_server) { create(:discord_server, external_id: 1) }

  let(:expected_json) do
    { 'id' => 1, 'last_donation' => expected_last_donation_json, 'setting' => expected_setting_json,
      'statistic' => expected_statistic_json, 'today_statistic' => expected_today_statistic_json }
  end
  let(:expected_last_donation_json) { nil }
  let(:expected_setting_json) do
    { 'autopause' => true, 'dj_role' => nil, 'language' => 'ru', 'prefix' => nil, 'volume' => 100 }
  end
  let(:expected_statistic_json) do
    { 'tracks_amount' => 0, 'tracks_length' => 0 }
  end
  let(:expected_today_statistic_json) do
    { 'date' => Time.zone.today.to_s, 'tracks_amount' => 0, 'tracks_length' => 0 }
  end

  it { expect(result).to eq(expected_json) }

  context 'when with donation' do
    let(:donation) do
      create(:donation, discord_server:, discord_user: nil, size: 10, date: donation_datetime)
    end
    let(:donation_datetime) { Time.current }
    let(:expected_last_donation_json) do
      { 'id' => donation.id, 'size' => 10, 'date' => donation_datetime.to_s, 'user_id' => nil, 'server_id' => 1 }
    end

    before { donation }

    it { expect(result).to eq(expected_json) }
  end

  context 'when with daily statistic' do
    let(:today_statistic) do
      create(:daily_statistic, discord_server:, tracks_amount: 10,
                               tracks_length: 10, date: Time.zone.today)
    end
    let(:expected_today_statistic_json) do
      { 'tracks_amount' => 10, 'tracks_length' => 10, 'date' => Time.zone.today.to_s }
    end

    before { today_statistic }

    it { expect(result).to eq(expected_json) }
  end

  context 'when several days after server start' do
    it do
      Timecop.freeze(1.week.from_now) do
        expect(result).to eq(expected_json)
      end
    end
  end
end

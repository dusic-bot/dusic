# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordServer, type: :model do
  subject(:instance) { build(:discord_server, external_id: external_id) }

  let(:external_id) { 482473013246296084 }

  it 'allows instance creation and creates statistic and setting', :aggregate_failures do
    expect { instance.save! }.not_to raise_error
    expect(instance.setting).to be_a(Setting)
    expect(instance.statistic).to be_a(Statistic)
  end

  context 'when nil id' do
    let(:external_id) { nil }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  context 'when already exists' do
    before { create(:discord_server, external_id: external_id) }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe '#today_statistic' do
    subject(:result) { instance.today_statistic }

    let(:instance) { create(:discord_server, external_id: external_id) }

    it { expect(result).to be_nil }

    context 'when DailyStatistic present' do
      let(:daily_statistic) { create(:daily_statistic, discord_server: ds_discord_server, date: ds_date) }
      let(:ds_discord_server) { instance }
      let(:ds_date) { Time.zone.today }

      before { daily_statistic }

      it { expect(result).to eq(daily_statistic) }

      context 'when DailyStatistic on another date' do
        let(:ds_discord_server) { create(:discord_server, external_id: 42) }

        it { expect(result).to be_nil }
      end

      context 'when DailyStatistic for another server' do
        let(:ds_date) { Time.zone.tomorrow }

        it { expect(result).to be_nil }
      end
    end
  end

  describe '#last_donation' do
    subject(:result) { instance.last_donation }

    let(:instance) { create(:discord_server, external_id: external_id) }

    it { expect(result).to be_nil }

    context 'when Donation present' do
      let(:donation) { create(:donation, discord_server: d_discord_server, date: d_date) }
      let(:d_discord_server) { instance }
      let(:d_date) { Time.zone.today }

      before { donation }

      it { expect(result).to eq(donation) }

      context 'when two Donations' do
        let(:donation_but_later) { create(:donation, discord_server: d_discord_server, date: d_date + 1.week) }

        before { donation_but_later }

        it { expect(result).to eq(donation_but_later) }
      end

      context 'when donation for another server' do
        let(:d_discord_server) { create(:discord_server, external_id: 42) }

        it { expect(result).to be_nil }
      end
    end
  end

  describe '#dm?' do
    subject(:result) { instance.dm? }

    it { expect(result).to be(false) }

    context 'when 0 id' do
      let(:external_id) { 0 }

      it { expect(result).to be(true) }
    end
  end
end

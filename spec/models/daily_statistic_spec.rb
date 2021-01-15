# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyStatistic, type: :model do
  subject(:instance) do
    build(:daily_statistic, discord_server: discord_server, tracks_length: tracks_length,
                            tracks_amount: tracks_amount, date: date)
  end

  let(:discord_server) { create(:discord_server) }
  let(:tracks_length) { 0 }
  let(:tracks_amount) { 0 }
  let(:date) { Date.current }

  it 'allows instance creation' do
    expect { instance.save! }.not_to raise_error
  end

  context 'when statistic for server already exist' do
    before { create(:daily_statistic, discord_server: discord_server, date: date) }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  context 'when tracks_amount is negative' do
    let(:tracks_amount) { -1 }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'when tracks_length is negative' do
    let(:tracks_length) { -1 }

    it 'fails instance creation' do
      expect { instance.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

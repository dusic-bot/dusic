# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiscordServerUpdaterService do
  subject(:call) { described_class.call(server, params) }

  let(:server) { create(:discord_server) }
  let(:params) { ActionController::Parameters.new(params_hash) }
  let(:params_hash) { {} }

  it { expect { call }.not_to(change { server }) }

  context 'when setting params specified' do
    let(:params_hash) do
      { setting: { dj_role: 1 } }
    end

    it do
      call
      expect(server.setting.dj_role).to eq(1)
    end
  end

  context 'when statistic params specified' do
    let(:params_hash) do
      { statistic: { tracks_amount: 1, tracks_length: 1 } }
    end

    it :aggregate_failures do
      call
      expect(server.statistic.tracks_amount).to eq(1)
      expect(server.statistic.tracks_length).to eq(1)
    end
  end

  context 'when today statistic param specified' do
    let(:params_hash) do
      { today_statistic: { date: date, tracks_amount: 1, tracks_length: 1 } }
    end
    let(:date) { '2020-05-01' }

    it :aggregate_failures do
      call
      daily_statistic = server.daily_statistics.find_by(date: date)
      expect(daily_statistic.tracks_amount).to eq(1)
      expect(daily_statistic.tracks_length).to eq(1)
    end
  end
end

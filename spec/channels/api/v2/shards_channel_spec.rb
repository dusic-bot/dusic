# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::ShardsChannel, type: :channel do
  let(:current_shard) { build(:shard_connection_data, shard_id: 0, shard_num: 1, bot_id: 42) }

  before { stub_connection(current_shard: current_shard) }

  describe '#subscribed' do
    it :aggregate_failures do
      subscribe
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_from('shards')
      expect(subscription).to have_stream_from('shards/0_1_42')
    end
  end

  describe '#connection_data' do
    let(:data) { {} }

    before do
      subscribe
      perform :connection_data, **data
    end

    it :aggregate_failures do
      expect(current_shard.servers_count).to eq(0)
      expect(current_shard.cached_servers_count).to eq(0)
      expect(current_shard.active_servers_count).to eq(0)
    end

    context 'when data is correct' do
      let(:data) { { 'servers_count' => 2, 'cached_servers_count' => 1, 'active_servers_count' => 0 } }

      it :aggregate_failures do
        expect(current_shard.servers_count).to eq(2)
        expect(current_shard.cached_servers_count).to eq(1)
        expect(current_shard.active_servers_count).to eq(0)
      end
    end
  end
end

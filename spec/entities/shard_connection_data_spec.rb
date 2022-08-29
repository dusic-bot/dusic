# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShardConnectionData do
  subject(:instance) do
    build(:shard_connection_data, shard_id:, shard_num:, bot_id:)
  end

  let(:shard_id) { 0 }
  let(:shard_num) { 0 }
  let(:bot_id) { 0 }

  describe '#==' do
    subject(:result) { instance == other }

    let(:other) { build(:shard_connection_data) }

    it { expect(result).to be(false) }

    context 'when same other' do
      let(:other) do
        build(:shard_connection_data, shard_id:, shard_num:, bot_id:)
      end

      it { expect(result).to be(true) }
    end
  end

  describe '#identifier' do
    subject(:result) { instance.identifier }

    let(:shard_id) { 0 }
    let(:shard_num) { 1 }
    let(:bot_id) { 13 }

    it { expect(result).to eq('0_1_13') }
  end

  describe 'attributes' do
    let(:current_time) { Time.utc(2022, 3, 8, 20, 0, 0) }

    it do
      Timecop.freeze(current_time) do
        expect(instance).to have_attributes(
          servers_count: nil, cached_servers_count: nil, active_servers_count: nil, created_at: current_time
        )
      end
    end
  end
end

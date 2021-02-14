# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShardConnectionData do
  subject(:instance) do
    build(:shard_connection_data, token: token, shard_id: shard_id, shard_num: shard_num, bot_id: bot_id)
  end

  let(:token) { '' }
  let(:shard_id) { 0 }
  let(:shard_num) { 0 }
  let(:bot_id) { 0 }

  describe '#authorized?' do
    subject(:result) { instance.authorized? }

    it { expect(result).to be(false) }

    context 'when correct data specified' do
      let(:token) { JwtEncoderService.call({ access_level: 1 }) }
      let(:shard_id) { 0 }
      let(:shard_num) { 1 }
      let(:bot_id) { 13 }

      it { expect(result).to be(true) }
    end
  end

  describe '#==' do
    subject(:result) { instance == other }

    let(:other) { build(:shard_connection_data) }

    it { expect(result).to be(false) }

    context 'when same other' do
      let(:other) do
        build(:shard_connection_data, token: token, shard_id: shard_id, shard_num: shard_num, bot_id: bot_id)
      end

      it { expect(result).to be(true) }
    end
  end
end

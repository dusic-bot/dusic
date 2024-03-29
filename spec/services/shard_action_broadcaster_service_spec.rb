# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShardActionBroadcasterService do
  subject(:call) { described_class.call(shard, action, payload) }

  let(:shard) { build(:shard_connection_data) }
  let(:action) { 'action' }
  let(:payload) { 42 }

  it do
    expect { call }.to have_broadcasted_to('shards/0_1_42').with(action: 'action', payload: 42)
  end
end

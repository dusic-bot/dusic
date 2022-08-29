# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommandCallExecutorService do
  subject(:call) { described_class.call(shard_identifier, payload) }

  let(:shard_identifier) { shard.identifier }
  let(:payload) { { 'stub' => true } }
  let(:shard) { build(:shard_connection_data) }

  let(:connection_stub) { instance_double('ApplicationCable::Connection', current_shard: shard) }

  before do
    allow(ActionCable.server.connections).to receive(:find).and_return(connection_stub)
  end

  it 'broadcasting message to shard', :aggregate_failures do
    expect(ShardActionBroadcasterService).to receive(:call).with(shard, 'command_call', { 'stub' => true })
    expect { call }.not_to raise_error
  end

  context 'when shard does not exist' do
    let(:connection_stub) { nil }

    it 'fails silently', :aggregate_failures do
      expect(ShardActionBroadcasterService).not_to receive(:call)
      expect { call }.not_to raise_error
    end
  end
end

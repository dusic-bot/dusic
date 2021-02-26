# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebsocketServerOrdererService do
  subject(:call) { described_class.call(command, shards) }

  let(:command) { nil }
  let(:shards) { nil }

  it { expect { call }.not_to raise_error }

  context 'when shards present' do
    let(:shard) { build(:shard_connection_data) }
    let(:shards) { [shard.identifier] }

    let(:connection_stub) { instance_double('ApplicationCable::Connection', current_shard: shard) }

    before do
      allow(ActionCable.server.connections).to receive(:find).and_return(connection_stub)
    end

    context 'when connection could not be found' do
      let(:connection_stub) { nil }

      it { expect { call }.not_to raise_error }
    end

    context 'when reload command' do
      let(:command) { 'reload' }

      it do
        expect { call }.not_to raise_error
      end
    end

    context 'when update_data command' do
      let(:command) { 'update_data' }

      it do
        expect(ShardActionBroadcasterService).to receive(:call).with(shard, 'update_data')
        call
      end
    end

    context 'when disconnect command' do
      let(:command) { 'disconnect' }

      it do
        expect(connection_stub).to receive(:close)
        call
      end
    end

    context 'when restart command' do
      let(:command) { 'restart' }

      it do
        expect(ShardActionBroadcasterService).to receive(:call).with(shard, 'restart')
        call
      end
    end

    context 'when stop command' do
      let(:command) { 'stop' }

      it do
        expect(ShardActionBroadcasterService).to receive(:call).with(shard, 'stop')
        call
      end
    end
  end
end

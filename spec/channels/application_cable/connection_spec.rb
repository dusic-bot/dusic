# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  subject(:request) { connect '/ws', params:, headers: }

  let(:params) do
    {
      shard_id:,
      shard_num:,
      bot_id:
    }
  end
  let(:headers) do
    {
      'Authorization' => token
    }
  end
  let(:token) { nil }
  let(:shard_id) { nil }
  let(:shard_num) { nil }
  let(:bot_id) { nil }

  it do
    expect { request }.to have_rejected_connection
  end

  context 'when valid' do
    let(:token) { JwtAuthorizationHeaderGeneratorService.call(access: { controllers: ['application_cable'] }) }
    let(:shard_id) { 0 }
    let(:shard_num) { 1 }
    let(:bot_id) { 42 }

    it do
      request
      expect(connection.current_shard.identifier).to eq('0_1_42')
    end
  end

  context 'when connection with same shard was already established' do
    let(:token) { JwtAuthorizationHeaderGeneratorService.call(access: { controllers: ['application_cable'] }) }
    let(:shard_id) { 0 }
    let(:shard_num) { 1 }
    let(:bot_id) { 42 }

    let(:another_connection) { connect '/ws', params: { shard_id:, shard_num:, bot_id: 43}, headers: }
    let(:previous_connection) { connect '/ws', params:, headers: }

    before do
      previous_connection
      another_connection
      allow(ActionCable.server).to receive(:connections).and_return([previous_connection, another_connection])
      allow(previous_connection).to receive(:close)
    end

    it 'disconnects previous connection', :aggregate_failures do
      expect(previous_connection).to receive(:close)
      expect(another_connection).not_to receive(:close)
      request
      expect(connection.current_shard.identifier).to eq('0_1_42')
    end
  end
end

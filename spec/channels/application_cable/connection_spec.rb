# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  subject(:request) { connect '/ws', params: params, headers: headers }

  let(:params) do
    {
      shard_id: shard_id,
      shard_num: shard_num,
      bot_id: bot_id
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
    let(:token) { JwtAuthorizationHeaderGeneratorService.call(access_level: 1) }
    let(:shard_id) { 0 }
    let(:shard_num) { 1 }
    let(:bot_id) { 42 }

    it do
      request
      expect(connection.current_shard.identifier).to eq('0_1_42')
    end
  end
end

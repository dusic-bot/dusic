# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  subject(:request) { connect '/ws', params: params }

  let(:params) do
    {
      token: token,
      shard_id: shard_id,
      shard_num: shard_num,
      bot_id: bot_id
    }
  end
  let(:token) { nil }
  let(:shard_id) { nil }
  let(:shard_num) { nil }
  let(:bot_id) { nil }
  let(:stubbed_connection) { instance_double(ShardConnectionData, authorized?: is_authorized) }
  let(:is_authorized) { false }

  before do
    allow(ShardConnectionData).to receive(:new).with('', 0, 0, 0).and_return(stubbed_connection)
  end

  it do
    expect { request }.to have_rejected_connection
  end

  context 'when valid' do
    let(:is_authorized) { true }

    it do
      request
      expect(connection.current_shard).to be(stubbed_connection)
    end
  end
end

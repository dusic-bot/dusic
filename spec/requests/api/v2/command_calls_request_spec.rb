# frozen_string_literal: true

require 'rails_helper'
require 'shared_contexts/api_v2_authorization'

RSpec.describe 'Api::V2::CommandCallsController', type: :request do
  subject(:response_json) { JSON.parse(response.body) }

  include_context 'with api v2 authorization', :post, '/api/v2/command_calls/', '/api/v2/command_calls/'

  describe 'POST #create' do
    subject(:request) do
      post '/api/v2/command_calls', params:, headers:
    end

    let(:params) { { application_id: '10', server_id: '4194305' } }

    let(:connections) do
      [
        instance_double(
          'ApplicationCable::Connection',
          current_shard: build(:shard_connection_data, shard_id: 0, shard_num: 2, bot_id: 10)
        ),
        instance_double(
          'ApplicationCable::Connection',
          current_shard: build(:shard_connection_data, shard_id: 1, shard_num: 2, bot_id: 10)
        ),
        instance_double(
          'ApplicationCable::Connection',
          current_shard: build(:shard_connection_data, shard_id: 0, shard_num: 1, bot_id: 11)
        )
      ]
    end

    before do
      allow(ActionCable.server).to receive(:connections).and_return(connections)
      allow(CommandCallExecutorService).to receive(:call)
    end

    it :aggregate_failures do
      expect(CommandCallExecutorService).to receive(:call).with('1_2_10', { 'server_id' => '4194305' })
      request
      expect(response).to have_http_status(:created)
    end
  end
end

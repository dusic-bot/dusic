# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V2::DiscordServersController', type: :request do
  subject(:response_json) { JSON.parse(response.body) }

  include_context 'with api v2 authorization', '/api/v2/discord_servers/'

  describe 'GET #index' do
    subject(:request) { get '/api/v2/discord_servers/', params: params, headers: headers }

    let(:params) { {} }
    let(:servers) { create_list(:discord_server, 5) }

    before { servers }

    it :aggregate_failures do
      request
      expect(response).to have_http_status(:ok)
      expect(response_json.pluck('id')).to eq(servers.pluck(:external_id))
    end

    context 'when shard data specified' do
      let(:params) { { shard_id: 0, shard_num: 1 } }

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:ok)
        expect(response_json.pluck('id')).to eq(servers.pluck(:external_id))
      end

      context 'when gibberish' do
        let(:params) { { shard_id: 'yes', shard_num: -1 } }

        it :aggregate_failures do
          request
          expect(response).to have_http_status(:ok)
          expect(response_json.pluck('id')).to eq(servers.pluck(:external_id))
        end
      end
    end
  end

  describe 'GET #show' do
    subject(:request) do
      get "/api/v2/discord_servers/#{requested_server_id}/", headers: headers
    end

    let(:requested_server_id) { '1' }
    let(:discord_server) { create(:discord_server, external_id: external_id) }
    let(:external_id) { 1 }

    before { allow(DiscordServerBlueprint).to receive(:render).with(discord_server).and_return(['stub']) }

    it :aggregate_failures do
      request
      expect(response).to have_http_status(:ok)
      expect(response_json).to eq(['stub'])
    end

    context 'when no such server' do
      let(:discord_server) { nil }

      before { allow(DiscordServerBlueprint).to receive(:render).and_return(['stub']) }

      it 'creates new one', :aggregate_failures do
        expect(DiscordServer).to receive(:create!)
        expect(DiscordServerBlueprint).to receive(:render)
        request
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(['stub'])
      end
    end

    context 'when bad id' do
      let(:requested_server_id) { 'abc' }

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when 0 id' do
      let(:requested_server_id) { '0' }
      let(:external_id) { 0 }

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(['stub'])
      end
    end
  end

  describe 'PUT #update' do
    subject(:request) do
      put "/api/v2/discord_servers/#{requested_server_id}/", params: params, headers: headers
    end

    let(:requested_server_id) { external_id }
    let(:discord_server) { create(:discord_server, external_id: external_id) }
    let(:external_id) { 1 }
    let(:params) { { 'stub' => true } }

    before do
      allow(DiscordServerUpdaterService).to receive(:call).and_return(true)
      allow(DiscordServerBlueprint).to receive(:render).and_return(['stub'])
    end

    it :aggregate_failures do
      expect(DiscordServerUpdaterService).to receive(:call)
      request
      expect(response).to have_http_status(:ok)
    end

    context 'when no such server' do
      let(:discord_server) { nil }

      it 'creates new one', :aggregate_failures do
        expect(DiscordServer).to receive(:create!).and_call_original
        expect(DiscordServerBlueprint).to receive(:render)
        expect(DiscordServerUpdaterService).to receive(:call)
        request
        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(['stub'])
      end
    end

    context 'when bad id' do
      let(:requested_server_id) { 'abc' }

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when 0 id' do
      let(:requested_server_id) { '0' }

      it :aggregate_failures do
        expect(DiscordServerUpdaterService).not_to receive(:call)
        request
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

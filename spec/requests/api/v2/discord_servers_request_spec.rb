# frozen_string_literal: true

require 'rails_helper'
require 'shared_contexts/api_v2_authorization'

RSpec.describe 'Api::V2::DiscordServersController' do
  subject(:response_json) { response.parsed_body }

  include_context 'with api v2 authorization', :get, '/api/v2/discord_servers/', '/api/v2/discord_servers/'

  describe 'GET #index' do
    subject(:request) { get '/api/v2/discord_servers/', params:, headers: }

    let(:params) { {} }
    let(:servers) { create_list(:discord_server, servers_count) }
    let(:servers_count) { 5 }

    before { servers }

    it :aggregate_failures do
      request
      expect(response).to have_http_status(:ok)
      expect(response_json.pluck('id')).to eq(servers.pluck(:external_id))
    end

    context 'when 2 servers got donations' do
      let(:server_with_donation) { create(:discord_server) }
      let(:donation) { create(:donation, discord_server: server_with_donation) }
      let(:server_with_donation2) { create(:discord_server) }
      let(:donation2) { create(:donation, discord_server: server_with_donation2) }

      let(:server_with_donation_json) do
        response_json.find { |json| json['id'] == server_with_donation.external_id }
      end
      let(:server_with_donation_json2) do
        response_json.find { |json| json['id'] == server_with_donation2.external_id }
      end

      before do
        donation
        donation2
      end

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:ok)
        expect(server_with_donation_json['last_donation']).not_to be_nil
        expect(server_with_donation_json2['last_donation']).not_to be_nil
      end
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
      get "/api/v2/discord_servers/#{requested_server_id}/", headers:
    end

    let(:requested_server_id) { '1' }
    let(:discord_server) { create(:discord_server, external_id:) }
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
      put "/api/v2/discord_servers/#{requested_server_id}/", params:, headers:
    end

    let(:requested_server_id) { external_id }
    let(:discord_server) { create(:discord_server, external_id:) }
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

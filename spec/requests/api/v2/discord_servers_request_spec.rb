# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V2::DiscordServersController', type: :request do
  subject(:response_json) { JSON.parse(response.body) }

  describe 'GET #index' do
    it :aggregate_failures do
      get '/api/v2/discord_servers/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end

  describe 'GET #show' do
    let(:discord_server) { create(:discord_server, external_id: external_id) }
    let(:external_id) { 1 }

    before { allow(DiscordServerBlueprint).to receive(:render).with(discord_server).and_return(['stub']) }

    it :aggregate_failures do
      get '/api/v2/discord_servers/1/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(response_json).to eq(['stub'])
    end

    context 'when no such server' do
      let(:discord_server) { nil }

      it do
        get '/api/v2/discord_servers/1/', headers: { 'Accept' => 'application/json' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PUT #update' do
    it :aggregate_failures do
      put '/api/v2/discord_servers/1/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end
end

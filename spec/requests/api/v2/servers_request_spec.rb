# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V2::ServersController', type: :request do
  describe 'GET #index' do
    it :aggregate_failures do
      get '/api/v2/servers/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end

  describe 'GET #show' do
    it :aggregate_failures do
      get '/api/v2/servers/1/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end

  describe 'PUT #update' do
    it :aggregate_failures do
      put '/api/v2/servers/1/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end
end

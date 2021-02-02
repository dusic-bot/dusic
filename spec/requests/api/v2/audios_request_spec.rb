# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V2::AudiosController', type: :request do
  describe 'GET #index' do
    it :aggregate_failures do
      get '/api/v2/audios/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_a(Hash)
      # TODO
    end
  end

  describe 'GET #show' do
    it :aggregate_failures do
      get '/api/v2/audios/vk/1_0_a_b/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end
end

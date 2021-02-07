# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V2::AudiosController', type: :request do
  subject(:response_json) { JSON.parse(response.body) }

  describe 'GET #index' do
    subject(:request) { get '/api/v2/audios/', params: params, headers: { 'Accept' => 'application/json' } }

    let(:params) { {} }
    let(:audio_response) { build(:audio_response) }

    before do
      allow(AudiosFetcherService).to receive(:call).and_return(audio_response)
      allow(AudioResponseBlueprint).to receive(:render).with(audio_response).and_return(['stub'])
    end

    it :aggregate_failures do
      request
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(['stub'])
    end
  end

  describe 'GET #show' do
    pending :aggregate_failures do
      get '/api/v2/audios/vk/1_0_a_b/', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      # TODO
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'shared_contexts/api_v2_authorization'

RSpec.describe 'Api::V2::AudiosController', type: :request do
  subject(:response_json) { JSON.parse(response.body) }

  include_context 'with api v2 authorization', '/api/v2/audios/'

  describe 'GET #index' do
    subject(:request) { get '/api/v2/audios/', headers: headers }

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
    subject(:request) do
      get "/api/v2/audios/#{manager}/#{id}/", params: params, headers: headers
    end

    let(:manager) { 'manager' }
    let(:id) { 'id' }
    let(:params) { {} }

    it do
      request
      expect(response).to have_http_status(:not_found)
    end

    context 'when vk manager' do
      let(:manager) { 'vk' }
      let(:response_io) { StringIO.new('data') }

      before { allow(AudioLoaderService).to receive(:call).and_return(response_io) }

      it :aggregate_failures do
        request
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq('data')
      end

      context 'when nil returned' do
        let(:response_io) { nil }

        it do
          request
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end

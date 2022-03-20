# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Audios', type: :request do
  describe 'GET #audios' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/audios', params:
    end

    let(:params) { {} }

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/audios/index')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end

    context 'when params specified' do
      let(:params) { { audios: { manager: 'vk', type: 'auto', query: 'test' } } }

      it :aggregate_failures do
        allow(AudiosFetcherService).to receive(:call).and_return(AudioResponse.empty)
        request
        expect(response).to render_template('admin/audios/index')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #audio' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get "/admin/audios/#{manager}/#{id}", params:
    end

    let(:params) { { format: 'mp3' } }
    let(:manager) { 'vk' }
    let(:id) { '1_0_a_b' }
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

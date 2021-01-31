# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Pages', type: :request do
  describe 'GET #root' do
    before { get '/admin/' }

    it { expect(response).to redirect_to(root_path) }

    context 'when logged in' do
      before do
        sign_in user
        get '/admin/'
      end

      let(:user) { create(:user, admin: is_admin) }
      let(:is_admin) { false }

      it { expect(response).to redirect_to(root_path) }

      context 'when logged in as admin' do
        let(:is_admin) { true }

        it :aggregate_failures do
          expect(response).to render_template('admin/pages/root')
          expect(response).to render_template('layouts/application')
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET #donation_id' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/donation_id', params: params
    end

    let(:params) { {} }

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/donation_id')
      expect(response).to render_template('layouts/application')
      expect(response).to have_http_status(:ok)
    end

    context 'when params specified' do
      let(:params) { { donation: { id: 'a_b' } } }

      it :aggregate_failures do
        expect(DonationIdDataFillerService).to receive(:call)
        request
        expect(response).to render_template('admin/pages/donation_id')
        expect(response).to render_template('layouts/application')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #audios' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/audios', params: params
    end

    let(:params) { {} }

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/audios')
      expect(response).to render_template('layouts/application')
      expect(response).to have_http_status(:ok)
    end

    context 'when params specified' do
      let(:params) { { audios: { manager: 'vk', type: 'auto', query: 'test' } } }

      it :aggregate_failures do
        allow(AudiosFetcherService).to receive(:call).and_return(AudioResponse.empty)
        request
        expect(response).to render_template('admin/pages/audios')
        expect(response).to render_template('layouts/application')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #audio' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/audio', params: params
    end

    let(:params) { {} }

    it do
      request
      expect(response).to have_http_status(:not_found)
    end

    context 'when params specified' do
      let(:params) { { audio: { manager: 'vk', id: '1_0_a_b', format: 'mp3' } } }
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

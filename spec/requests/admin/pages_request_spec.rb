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
          expect(response).to render_template('layouts/admin_application')
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
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end

    context 'when params specified' do
      let(:params) { { donation: { id: 'a_b' } } }

      it :aggregate_failures do
        expect(DonationIdDataFillerService).to receive(:call)
        request
        expect(response).to render_template('admin/pages/donation_id')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #jwt_token' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/jwt_token'
    end

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/jwt_token')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #jwt_token' do
    subject(:request) do
      sign_in create(:user, admin: true)
      post '/admin/jwt_token', params: params
    end

    let(:params) { {} }

    it :aggregate_failures do
      request
      expect(flash[:alert]).to be_blank
      expect(response).to render_template('admin/pages/jwt_token')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end

    context 'when payload provided' do
      let(:params) { { payload: '{}' } }

      it :aggregate_failures do
        request
        expect(flash[:alert]).to be_blank
        expect(response).to render_template('admin/pages/jwt_token')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end

      context 'when wrong payload' do
        let(:params) { { payload: 'e' } }

        it :aggregate_failures do
          request
          expect(flash[:alert]).not_to be_blank
          expect(response).to render_template('admin/pages/jwt_token')
          expect(response).to render_template('layouts/admin_application')
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe 'GET #websocket_server' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/websocket_server'
    end

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/websocket_server')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #websocket_server' do
    subject(:request) do
      sign_in create(:user, admin: true)
      post '/admin/websocket_server', params: params
    end

    let(:params) { {} }

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/websocket_server')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end

    context 'when with parameters' do
      let(:params) { { websocket_server: { action: 'action', clients: %w[arg1 arg2] } } }

      it :aggregate_failures do
        expect(WebsocketServerOrdererService).to receive(:call).with('action', %w[arg1 arg2])
        request
        expect(response).to render_template('admin/pages/websocket_server')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'GET #donation_adder' do
    subject(:request) do
      sign_in create(:user, admin: true)
      get '/admin/donation_adder'
    end

    it :aggregate_failures do
      request
      expect(response).to render_template('admin/pages/donation_adder')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #donation_adder' do
    subject(:request) do
      sign_in create(:user, admin: true)
      post '/admin/donation_adder', params: params
    end

    let(:params) { {} }

    it :aggregate_failures do
      expect(DonationAdderService).not_to receive(:call)
      request
      expect(response).to render_template('admin/pages/donation_adder')
      expect(response).to render_template('layouts/admin_application')
      expect(response).to have_http_status(:ok)
    end

    context 'when with parameters' do
      let(:params) { { donation: { message: 'msg', size: 10, date: '2021-03-14' } } }

      it :aggregate_failures do
        expect(DonationAdderService).to receive(:call).and_call_original
        request
        expect(flash.notice).to eq('Donation created')
        expect(response).to render_template('admin/pages/donation_adder')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when params are empty' do
      let(:params) { { donation: {} } }

      it :aggregate_failures do
        expect(DonationAdderService).not_to receive(:call)
        request
        expect(response).to render_template('admin/pages/donation_adder')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when params are gibberish' do
      let(:params) { { donation: { message: 'msg', size: 10, date: 'random date lol' } } }

      it :aggregate_failures do
        expect(DonationAdderService).to receive(:call).and_call_original
        request
        expect(flash.alert).to eq('Please specify correct date!')
        expect(response).to render_template('admin/pages/donation_adder')
        expect(response).to render_template('layouts/admin_application')
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

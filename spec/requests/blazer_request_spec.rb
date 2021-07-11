# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blazer', type: :request do
  describe 'GET blazer#index' do
    before { get '/admin/blazer' }

    it { expect(response).to redirect_to('/') }

    context 'when logged in' do
      before do
        sign_in user
        get '/admin/rails'
      end

      let(:user) { create(:user, admin: is_admin) }
      let(:is_admin) { false }

      it { expect(response).to redirect_to('/') }

      context 'when logged in as admin' do
        let(:is_admin) { true }

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end

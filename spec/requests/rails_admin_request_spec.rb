# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RailsAdmin', type: :request do
  describe 'GET rails_admin/main#dashboard' do
    before { get '/admin/rails' }

    it { expect(response).to redirect_to(new_user_session_path) }

    context 'when logged in' do
      before do
        sign_in user
        get '/admin/rails'
      end

      let(:user) { User.create(email: 'example@email.com', password: 'password', admin: is_admin) }
      let(:is_admin) { false }

      it { expect(response).to redirect_to('/') }

      context 'when logged in as admin' do
        let(:is_admin) { true }

        it { expect(response).to have_http_status(:ok) }
      end
    end
  end
end

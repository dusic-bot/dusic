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
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET devise/registrations#new' do
    it :aggregate_failures do
      get signup_path
      expect(response).to render_template('layouts/application')
      expect(response).to have_http_status(:ok)
    end

    context 'when admin user exists' do
      before { create(:user, admin: true) }

      it do
        get signup_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

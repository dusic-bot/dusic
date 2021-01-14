# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET devise/registrations#new' do
    it :aggregate_failures do
      get '/users/sign_up'
      expect(response).to render_template('layouts/application')
      expect(response).to have_http_status(:ok)
    end
  end
end

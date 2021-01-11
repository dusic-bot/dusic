# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET #root' do
    it :aggregate_failures do
      get '/'
      expect(response).to render_template('pages/root')
      expect(response).to render_template('layouts/application')
      expect(response).to have_http_status(:ok)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'with api v2 authorization' do |sample_url, accessed_controller|
  let(:headers) { { 'Accept' => 'application/json', 'Authorization' => authorization_token } }
  let(:authorization_token) { JwtAuthorizationHeaderGeneratorService.call(**authorization_params) }
  let(:authorization_params) { { access: { controllers: [accessed_controller] } } }

  context 'when not authorized' do
    subject(:request) { get sample_url, headers: headers }

    let(:authorization_params) { { access: { controllers: [] } } }

    before { request }

    it { expect(response).to have_http_status(:unauthorized) }

    context 'when no authorization token' do
      let(:authorization_token) { 'please' }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end

  context 'when not authorized in deprecated format' do
    subject(:request) { get sample_url, headers: headers }

    let(:authorization_params) { { access_level: 0 } }

    before { request }

    it { expect(response).to have_http_status(:unauthorized) }

    context 'when no authorization token' do
      let(:authorization_token) { 'please' }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end

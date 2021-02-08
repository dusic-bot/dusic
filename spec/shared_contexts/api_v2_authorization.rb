# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_context 'with api v2 authorization' do |sample_url, params|
  let(:headers) { { 'Accept' => 'application/json', 'Authorization' => authorization_token } }
  let(:authorization_token) { JwtAuthorizationHeaderGeneratorService.call(access_level: access_level) }
  let(:access_level) { 1 }

  context 'when not authorized' do
    subject(:request) { get sample_url, params: params, headers: headers }

    let(:access_level) { 0 }

    before { request }

    it { expect(response).to have_http_status(:unauthorized) }

    context 'when no authorization token' do
      let(:authorization_token) { 'please' }

      it { expect(response).to have_http_status(:unauthorized) }
    end
  end
end

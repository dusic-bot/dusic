# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizerService do
  subject(:result) { described_class.call(request, access_level: required_access_level) }

  let(:request) { nil }
  let(:required_access_level) { 42 }

  it { expect(result).to be(false) }

  context 'when with actual request' do
    let(:request) { instance_double('ActionDispatch::Request', headers: headers) }
    let(:headers) { {} }

    it { expect(result).to be(false) }

    context 'when empty header present' do
      let(:headers) { { 'Authorization' => nil } }

      it { expect(result).to be(false) }
    end

    context 'when incorrect header present' do
      let(:headers) { { 'Authorization' => 'Pizza time' } }

      it { expect(result).to be(false) }
    end

    context 'when correct header present' do
      let(:headers) do
        { 'Authorization' => JwtAuthorizationHeaderGeneratorService.call(access_level: access_level) }
      end
      let(:access_level) { 100500 }

      it { expect(result).to be(true) }

      context 'when access level is low' do
        let(:access_level) { 0 }

        it { expect(result).to be(false) }
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtRequestAuthorizerService do
  subject(:result) { described_class.call(request, **options) }

  let(:request) { nil }
  let(:options) { { controller: 'stub' } }

  it :aggregate_failures do
    expect(JwtAuthorizerService).not_to receive(:call)
    expect(result).to be(false)
  end

  context 'when with actual request' do
    let(:request) { instance_double(ActionDispatch::Request, headers:) }
    let(:headers) { {} }

    it :aggregate_failures do
      expect(JwtAuthorizerService).not_to receive(:call)
      expect(result).to be(false)
    end

    context 'when empty header present' do
      let(:headers) { { 'Authorization' => nil } }

      it :aggregate_failures do
        expect(JwtAuthorizerService).to receive(:call).with('', **options).and_call_original
        expect(result).to be(false)
      end
    end

    context 'when incorrect header present' do
      let(:headers) { { 'Authorization' => 'Pizza time' } }

      it :aggregate_failures do
        expect(JwtAuthorizerService).to receive(:call).with('Pizza time', **options).and_call_original
        expect(result).to be(false)
      end
    end

    context 'when correct header present' do
      let(:headers) do
        { 'Authorization' => 'Bearer STUB' }
      end

      before { allow(JwtAuthorizerService).to receive(:call).with('STUB', **options).and_return(true) }

      it :aggregate_failures do
        expect(JwtAuthorizerService).to receive(:call).with('STUB', **options)
        expect(result).to be(true)
      end
    end
  end
end

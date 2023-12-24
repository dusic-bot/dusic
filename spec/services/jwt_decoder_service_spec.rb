# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtDecoderService do
  subject(:result) { described_class.call(token) }

  let(:token) { '' }

  it { expect(result).to be_nil }

  context 'when encoded data provided' do
    let(:token) { JwtEncoderService.call(payload) }
    let(:payload) { { 'data' => 'stub' } }

    it :aggregate_failures do
      expect(result).to be_a(ActiveSupport::HashWithIndifferentAccess)
      expect(result).to eq(payload)
    end
  end
end

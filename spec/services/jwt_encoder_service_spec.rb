# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtEncoderService do
  subject(:result) { described_class.call(payload) }

  let(:payload) { {} }

  it { expect(result).to be_a(String) }

  context 'when checking the decoded data' do
    let(:payload) { { 'data' => 'stub' } }

    it { expect(JwtDecoderService.call(result)).to eq(payload) }
  end
end

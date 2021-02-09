# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizationHeaderGeneratorService do
  subject(:result) { described_class.call(access_level: access_level) }

  let(:access_level) { 42 }

  it :aggregate_failures do
    expect(result).to be_a(String)
    expect(result).to start_with('Bearer ')
    expect(JwtDecoderService.call(result.delete_prefix('Bearer '))).to eq({ 'access_level' => 42 })
  end
end

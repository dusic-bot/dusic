# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizationHeaderGeneratorService do
  subject(:result) { described_class.call(stub: true) }

  before do
    allow(JwtEncoderService).to receive(:call).with(stub: true).and_return('JWT')
  end

  it { expect(result).to eq('Bearer JWT') }
end

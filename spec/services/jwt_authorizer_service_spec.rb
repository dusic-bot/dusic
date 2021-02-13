# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizerService do
  subject(:result) { described_class.call(token, access_level: required_access_level) }

  let(:token) { nil }
  let(:required_access_level) { 42 }

  it { expect(result).to be(false) }

  context 'when empty token' do
    let(:token) { '' }

    it { expect(result).to be(false) }

    context 'when incorrect header present' do
      let(:token) { 'Pizza time' }

      it { expect(result).to be(false) }
    end

    context 'when correct header present' do
      let(:token) { JwtEncoderService.call(access_level: access_level) }
      let(:access_level) { 100500 }

      it { expect(result).to be(true) }

      context 'when JwtDecoderService raises error' do
        before { allow(JwtDecoderService).to receive(:call).and_raise(StandardError) }

        it { expect(result).to be(false) }
      end

      context 'when access level is low' do
        let(:access_level) { 0 }

        it { expect(result).to be(false) }
      end
    end
  end
end

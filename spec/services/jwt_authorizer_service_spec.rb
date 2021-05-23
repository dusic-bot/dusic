# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtAuthorizerService do
  subject(:result) { described_class.call(token, controller: required_controller) }

  let(:token) { nil }
  let(:required_controller) { 'first' }

  it { expect(result).to be(false) }

  context 'when empty token' do
    let(:token) { '' }

    it { expect(result).to be(false) }
  end

  context 'when incorrect header present' do
    let(:token) { 'Pizza time' }

    it { expect(result).to be(false) }
  end

  context 'when correct header present' do
    let(:token) { JwtEncoderService.call(access: { controllers: allowed_controllers }) }
    let(:allowed_controllers) { %w[first] }

    it { expect(result).to be(true) }

    context 'when JwtDecoderService raises error' do
      before { allow(JwtDecoderService).to receive(:call).and_raise(StandardError) }

      it { expect(result).to be(false) }
    end

    context 'when access level is incorrect' do
      let(:allowed_controllers) { %w[second] }

      it { expect(result).to be(false) }
    end

    context 'when several allowed controllers' do
      let(:allowed_controllers) { %w[first second] }

      it { expect(result).to be(true) }
    end

    context 'when several allowed controllers without required one' do
      let(:allowed_controllers) { %w[second third] }

      it { expect(result).to be(false) }
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AudioResponse do
  subject(:instance) { described_class.new(request_type, response) }

  let(:request_type) { 'request_type_stub' }
  let(:response) { 'response_stub' }

  describe '.new' do
    it { expect { instance }.not_to raise_error }
  end

  describe '.empty' do
    subject(:call) { described_class.empty }

    it do
      expect(described_class).to receive(:new).with(nil, nil)
      call
    end
  end

  describe '#request_type' do
    subject(:result) { instance.request_type }

    it { expect(result).to be(request_type) }
  end

  describe '#response' do
    subject(:result) { instance.response }

    it { expect(result).to be(response) }
  end

  describe '#empty?' do
    subject(:result) { instance.empty? }

    it { expect(result).to be(false) }

    context 'when request_type is nil' do
      let(:request_type) { nil }

      it { expect(result).to be(true) }
    end

    context 'when response is nil' do
      let(:response) { nil }

      it { expect(result).to be(true) }
    end
  end
end

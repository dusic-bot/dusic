# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DonationAdderService do
  subject(:call) { described_class.call(params) }

  let(:params) { { message:, size:, date: } }
  let(:message) { 'msg' }
  let(:size) { 10 }
  let(:date) { '2021-03-14' }

  it do
    expect(DonationCreatorService).to receive(:call).with(10, DateTime.new(2021, 3, 14, 0, 0, 0, 0), 'msg')
    call
  end

  context 'when size is string' do
    let(:size) { '10' }

    it do
      expect(DonationCreatorService).to receive(:call).with(10, DateTime.new(2021, 3, 14, 0, 0, 0, 0), 'msg')
      call
    end
  end

  context 'when size is empty' do
    let(:size) { nil }

    it do
      expect(DonationCreatorService).to receive(:call).with(0, DateTime.new(2021, 3, 14, 0, 0, 0, 0), 'msg')
      call
    end
  end

  context 'when date is empty' do
    let(:date) { nil }

    it :aggregate_failures do
      expect(DonationCreatorService).not_to receive(:call)
      expect { call }.to raise_error(Date::Error)
    end
  end

  context 'when date is gibberish' do
    let(:date) { 'random date' }

    it :aggregate_failures do
      expect(DonationCreatorService).not_to receive(:call)
      expect { call }.to raise_error(Date::Error)
    end
  end
end

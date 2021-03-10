# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkponchikDonationsCheckerService do
  subject(:call) { described_class.call }

  let(:client) { instance_double(Vkponchik::Client) }
  let(:stub_requests) do
    allow(client).to receive(:request).with('donates/get', len: 3, offset: 0).and_return({ list: [] })
  end

  before do
    stub_const('VKPONCHIK_CLIENT', client)
    stub_const("#{described_class}::REQUEST_COUNT", 3)
    stub_const("#{described_class}::PAGES_FETCH_INTERVAL", 0.seconds)
    stub_requests
  end

  it do
    expect(VkponchikDonationCreatorService).not_to receive(:call)
    call
  end

  context 'when pre-defined donations existed' do
    before do
      create(:vkponchik_donation, external_id: 2)
      create(:vkponchik_donation, external_id: 1)
    end

    it do
      expect(VkponchikDonationCreatorService).not_to receive(:call)
      call
    end

    context 'when no new donations' do
      let(:stub_requests) do
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 2 }, { 'id' => 1 }] })
      end

      it do
        expect(VkponchikDonationCreatorService).not_to receive(:call)
        call
      end
    end

    context 'when 1 new donation' do
      let(:stub_requests) do
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 3 }, { 'id' => 2 }, { 'id' => 1 }] })
      end

      it do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end

    context 'when 2 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 4 }, { 'id' => 3 }, { 'id' => 2 }] })
      end

      it :aggregate_failures do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 4 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end

    context 'when 3 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 5 }, { 'id' => 4 }, { 'id' => 3 }] })
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 3).and_return({ list: [{ 'id' => 2 }, { 'id' => 1 }] })
      end

      it :aggregate_failures do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 5 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 4 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end

    context 'when 4 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 6 }, { 'id' => 5 }, { 'id' => 4 }] })
        allow(client).to receive(:request)
          .with('donates/get', len: 3, offset: 3).and_return({ list: [{ 'id' => 3 }, { 'id' => 2 }, { 'id' => 1 }] })
      end

      it :aggregate_failures do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 6 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 5 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 4 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end
  end

  context 'when request raises error' do
    let(:stub_requests) do
      allow(client).to receive(:request).with('donates/get', len: 3, offset: 0).and_raise('Connection error')
    end

    it do
      expect(VkponchikDonationCreatorService).not_to receive(:call)
      call
    end
  end

  context 'when 1 new donation' do
    let(:stub_requests) do
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 1 }] })
    end

    it do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end

  context 'when 2 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 2 }, { 'id' => 1 }] })
    end

    it :aggregate_failures do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 2 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end

  context 'when 3 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 3 }, { 'id' => 2 }, { 'id' => 1 }] })
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 3).and_return({ list: [] })
    end

    it :aggregate_failures do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 2 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end

  context 'when 4 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 0).and_return({ list: [{ 'id' => 4 }, { 'id' => 3 }, { 'id' => 2 }] })
      allow(client).to receive(:request)
        .with('donates/get', len: 3, offset: 3).and_return({ list: [{ 'id' => 1 }] })
    end

    it :aggregate_failures do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 4 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 2 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end
end

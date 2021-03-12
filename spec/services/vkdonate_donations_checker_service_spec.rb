# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkdonateDonationsCheckerService do
  subject(:call) { described_class.call }

  let(:client) { instance_double(Vkdonate::Client) }
  let(:stub_requests) do
    allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([])
  end
  let(:donation1) { instance_double('Vkdonate::Donation', id: 1) }
  let(:donation2) { instance_double('Vkdonate::Donation', id: 2) }
  let(:donation3) { instance_double('Vkdonate::Donation', id: 3) }
  let(:donation4) { instance_double('Vkdonate::Donation', id: 4) }
  let(:donation5) { instance_double('Vkdonate::Donation', id: 5) }
  let(:donation6) { instance_double('Vkdonate::Donation', id: 6) }

  before do
    stub_const('VKDONATE_CLIENT', client)
    stub_const("#{described_class}::REQUEST_COUNT", 3)
    stub_const("#{described_class}::PAGES_FETCH_INTERVAL", 0.seconds)
    stub_requests
  end

  it do
    expect(VkdonateDonationCreatorService).not_to receive(:call)
    call
  end

  context 'when pre-defined donations existed' do
    before do
      create(:vkdonate_donation, external_id: 2)
      create(:vkdonate_donation, external_id: 1)
    end

    it do
      expect(VkdonateDonationCreatorService).not_to receive(:call)
      call
    end

    context 'when no new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation2, donation1])
      end

      it do
        expect(VkdonateDonationCreatorService).not_to receive(:call)
        call
      end
    end

    context 'when 1 new donation' do
      let(:stub_requests) do
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation3, donation2, donation1])
      end

      it do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
        call
      end
    end

    context 'when 2 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation4, donation3, donation2])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation4)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
        call
      end
    end

    context 'when 3 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation5, donation4, donation3])
        allow(client).to receive(:donates).with(count: 3, offset: 3).and_return([donation2, donation1])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation5)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation4)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
        call
      end
    end

    context 'when 4 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation6, donation5, donation4])
        allow(client).to receive(:donates).with(count: 3, offset: 3).and_return([donation3, donation2, donation1])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation6)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation5)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation4)
        expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
        call
      end
    end
  end

  context 'when request raises error' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_raise('Connection error')
    end

    it do
      expect(VkdonateDonationCreatorService).not_to receive(:call)
      call
    end
  end

  context 'when 1 new donation' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation1])
    end

    it do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation1)
      call
    end
  end

  context 'when 2 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation2, donation1])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation2)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation1)
      call
    end
  end

  context 'when 3 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation3, donation2, donation1])
      allow(client).to receive(:donates).with(count: 3, offset: 3).and_return([])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation2)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation1)
      call
    end
  end

  context 'when 4 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donation4, donation3, donation2])
      allow(client).to receive(:donates).with(count: 3, offset: 3).and_return([donation1])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation4)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation3)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation2)
      expect(VkdonateDonationCreatorService).to receive(:call).with(donation1)
      call
    end
  end
end

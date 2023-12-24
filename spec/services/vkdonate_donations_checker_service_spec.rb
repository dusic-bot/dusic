# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkdonateDonationsCheckerService do
  subject(:call) { described_class.call }

  let(:client) { instance_double(Vkdonate::Client) }
  let(:stub_requests) do
    allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([])
  end
  let(:donations) do
    [
      instance_double(Vkdonate::Donate, id: 1),
      instance_double(Vkdonate::Donate, id: 2),
      instance_double(Vkdonate::Donate, id: 3),
      instance_double(Vkdonate::Donate, id: 4),
      instance_double(Vkdonate::Donate, id: 5),
      instance_double(Vkdonate::Donate, id: 6)
    ]
  end

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
        allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donations[1], donations[0]])
      end

      it do
        expect(VkdonateDonationCreatorService).not_to receive(:call)
        call
      end
    end

    context 'when 1 new donation' do
      let(:stub_requests) do
        allow(client).to receive(:donates)
          .with(count: 3, offset: 0).and_return([donations[2], donations[1], donations[0]])
      end

      it do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
        call
      end
    end

    context 'when 2 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates)
          .with(count: 3, offset: 0).and_return([donations[3], donations[2], donations[1]])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[3])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
        call
      end
    end

    context 'when 3 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates)
          .with(count: 3, offset: 0).and_return([donations[4], donations[3], donations[2]])
        allow(client).to receive(:donates)
          .with(count: 3, offset: 3).and_return([donations[1], donations[0]])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[4])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[3])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
        call
      end
    end

    context 'when 4 new donations' do
      let(:stub_requests) do
        allow(client).to receive(:donates)
          .with(count: 3, offset: 0).and_return([donations[5], donations[4], donations[3]])
        allow(client).to receive(:donates)
          .with(count: 3, offset: 3).and_return([donations[2], donations[1], donations[0]])
      end

      it :aggregate_failures do
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[5])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[4])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[3])
        expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
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
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donations[0]])
    end

    it do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[0])
      call
    end
  end

  context 'when 2 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates).with(count: 3, offset: 0).and_return([donations[1], donations[0]])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[1])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[0])
      call
    end
  end

  context 'when 3 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates)
        .with(count: 3, offset: 0).and_return([donations[2], donations[1], donations[0]])
      allow(client).to receive(:donates)
        .with(count: 3, offset: 3).and_return([])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[1])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[0])
      call
    end
  end

  context 'when 4 new donations' do
    let(:stub_requests) do
      allow(client).to receive(:donates)
        .with(count: 3, offset: 0).and_return([donations[3], donations[2], donations[1]])
      allow(client).to receive(:donates)
        .with(count: 3, offset: 3).and_return([donations[0]])
    end

    it :aggregate_failures do
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[3])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[2])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[1])
      expect(VkdonateDonationCreatorService).to receive(:call).with(donations[0])
      call
    end
  end
end

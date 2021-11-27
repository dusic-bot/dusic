# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkponchikDonationsCheckerService do
  subject(:call) { described_class.call }

  let(:client) { instance_double(Vkponchik::Client) }
  let(:stub_requests) do
    allow(client).to receive(:request).with('donates/get-last', last: nil).and_return({ list: stubbed_fetched_list })
  end
  let(:stubbed_fetched_list) { [] }

  before do
    stub_const('VKPONCHIK_CLIENT', client)
    stub_requests
  end

  it do
    expect(VkponchikDonationCreatorService).not_to receive(:call)
    call
  end

  context 'when pre-defined donations existed' do
    let(:stub_requests) do
      allow(client).to receive(:request).with('donates/get-last', last: 2).and_return({ list: stubbed_fetched_list })
    end

    before do
      create(:vkponchik_donation, external_id: 2)
      create(:vkponchik_donation, external_id: 1)
    end

    it do
      expect(VkponchikDonationCreatorService).not_to receive(:call)
      call
    end

    context 'when 1 new donation' do
      let(:stubbed_fetched_list) { [{ 'id' => 3 }] }

      it do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end

    context 'when 2 new donations' do
      let(:stubbed_fetched_list) { [{ 'id' => 3 }, { 'id' => 4 }] }

      it :aggregate_failures do
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 4 })
        expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 3 })
        call
      end
    end
  end

  context 'when request raises error' do
    let(:stub_requests) do
      allow(client).to receive(:request).and_raise('Connection error')
    end

    it do
      expect(VkponchikDonationCreatorService).not_to receive(:call)
      call
    end
  end

  context 'when 1 new donation' do
    let(:stubbed_fetched_list) { [{ 'id' => 1 }] }

    it do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end

  context 'when 2 new donations' do
    let(:stubbed_fetched_list) { [{ 'id' => 1 }, { 'id' => 2 }] }

    it :aggregate_failures do
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 2 })
      expect(VkponchikDonationCreatorService).to receive(:call).with({ 'id' => 1 })
      call
    end
  end
end

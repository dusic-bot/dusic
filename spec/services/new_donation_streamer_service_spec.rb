# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewDonationStreamerService do
  subject(:call) { described_class.call(donation) }

  let(:donation) { build_stubbed(:donation) }

  before do
    allow(DonationBlueprint).to receive(:render_as_hash).with(donation).and_return({ stub: 'true' })
  end

  it do
    expect { call }.to have_broadcasted_to('donations/create').with(stub: 'true')
  end
end

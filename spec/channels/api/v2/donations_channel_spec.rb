# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V2::DonationsChannel, type: :channel do
  let(:current_shard) { build(:shard_connection_data, shard_id: 0, shard_num: 1, bot_id: 42) }

  before { stub_connection(current_shard:) }

  it :aggregate_failures do
    subscribe
    expect(subscription).to be_confirmed
    expect(subscription).to have_stream_from('donations/create')
  end
end

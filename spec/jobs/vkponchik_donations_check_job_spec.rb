# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VkponchikDonationsCheckJob do
  before do
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true
  end

  it :aggregate_failures do
    expect(VkponchikDonationsCheckerService).to receive(:call)
    described_class.perform_later
    expect(described_class).to have_been_performed.on_queue('donations').exactly(:once)
    expect(described_class).to have_been_enqueued.on_queue('donations').exactly(:once)
  end
end

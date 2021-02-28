# frozen_string_literal: true

class VkponchikDonationsCheckJob < ApplicationJob
  INTERVAL = 45.seconds

  queue_as :donations

  after_perform { reschedule }

  def perform
    VkponchikDonationsCheckService.call
  end

  private

  def reschedule
    self.class.set(wait: INTERVAL).perform_later
  end
end

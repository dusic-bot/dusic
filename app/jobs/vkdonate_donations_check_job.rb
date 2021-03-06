# frozen_string_literal: true

class VkdonateDonationsCheckJob < ApplicationJob
  INTERVAL = 45.seconds

  queue_as :donations

  after_perform { reschedule }

  def perform
    VkdonateDonationsCheckService.call
  end

  private

  def reschedule
    self.class.set(wait: INTERVAL).perform_later
  end
end

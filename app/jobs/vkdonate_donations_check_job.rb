# frozen_string_literal: true

class VkdonateDonationsCheckJob < ApplicationJob
  INTERVAL = 90.seconds

  queue_as :donations

  before_perform { reschedule }

  def perform
    VkdonateDonationsCheckerService.call
  end

  private

  def reschedule
    self.class.set(wait: INTERVAL).perform_later
  end
end

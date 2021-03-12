# frozen_string_literal: true

class VkponchikDonationsCheckJob < ApplicationJob
  INTERVAL = 45.minutes # TODO: AFTER FULL RELEASE: minutes -> seconds

  queue_as :donations

  after_perform { reschedule }

  def perform
    VkponchikDonationsCheckerService.call
  end

  private

  def reschedule
    self.class.set(wait: INTERVAL).perform_later
  end
end

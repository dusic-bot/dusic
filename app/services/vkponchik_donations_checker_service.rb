# frozen_string_literal: true

class VkponchikDonationsCheckerService < ExternalDonationsCheckerService
  class << self
    private

    def fetch_donations_until(last_external_id)
      unsafe_fetch(last_external_id)
    rescue StandardError => e
      Rails.logger.error "#{donation_class} request error: #{e}\n#{e.backtrace}"
      []
    end

    def donation_class
      VkponchikDonation
    end

    def donation_creator_service
      VkponchikDonationCreatorService
    end

    def unsafe_fetch(last_external_id)
      ::VKPONCHIK_CLIENT.request('donates/get-last', last: last_external_id)[:list]
    end
  end
end

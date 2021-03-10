# frozen_string_literal: true

class VkponchikDonationsCheckerService < ExternalDonationsCheckerService
  REQUEST_COUNT = 100
  PAGES_FETCH_INTERVAL = 6.seconds

  class << self
    private

    def request_count
      REQUEST_COUNT
    end

    def pages_fetch_interval
      PAGES_FETCH_INTERVAL
    end

    def donation_class
      VkponchikDonation
    end

    def donation_creator_service
      VkponchikDonationCreatorService
    end

    def unsafe_fetch(offset)
      ::VKPONCHIK_CLIENT.request('donates/get', len: REQUEST_COUNT, offset: offset)[:list]
    end

    def donation_external_id(donation)
      donation['id'].to_i
    end
  end
end

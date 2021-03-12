# frozen_string_literal: true

class VkdonateDonationsCheckerService < ExternalDonationsCheckerService
  REQUEST_COUNT = 50
  PAGES_FETCH_INTERVAL = 5.seconds

  class << self
    private

    def request_count
      REQUEST_COUNT
    end

    def pages_fetch_interval
      PAGES_FETCH_INTERVAL
    end

    def donation_class
      VkdonateDonation
    end

    def donation_creator_service
      VkdonateDonationCreatorService
    end

    def unsafe_fetch(offset)
      ::VKDONATE_CLIENT.donates(count: REQUEST_COUNT, offset: offset)
    end

    def donation_external_id(donation)
      donation.id
    end
  end
end

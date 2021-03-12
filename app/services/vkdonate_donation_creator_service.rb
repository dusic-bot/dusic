# frozen_string_literal: true

class VkdonateDonationCreatorService < ExternalDonationCreatorService
  class << self
    private

    def size(data)
      data.sum
    end

    def date(data)
      data.date
    end

    def message(data)
      data.message
    end

    def vk_user_external_id(data)
      data.uid
    end

    def external_id(data)
      data.id
    end

    def donation_class
      VkdonateDonation
    end
  end
end

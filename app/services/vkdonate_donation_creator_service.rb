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

    def previous_donations_query(data)
      external_donations = VkdonateDonation.where(vk_user_external_id: vk_user_external_id(data))

      Donation.where(id: external_donations.select(:donation_id))
    end
  end
end

# frozen_string_literal: true

class VkponchikDonationCreatorService < ExternalDonationCreatorService
  class << self
    private

    def size(data)
      data['amount']&.to_i
    end

    def date(data)
      data['date'] ? Time.zone.at(data['date'].to_i / 1000) : nil
    end

    def message(data)
      data['msg']
    end

    def vk_user_external_id(data)
      data['user']&.to_i
    end

    def external_id(data)
      data['id']&.to_i
    end

    def donation_class
      VkponchikDonation
    end

    def previous_donations_query(data)
      external_donations = VkponchikDonation.where(vk_user_external_id: vk_user_external_id(data))

      Donation.where(id: external_donations.select(:donation_id))
    end
  end
end

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
  end
end

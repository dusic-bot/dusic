# frozen_string_literal: true

class ExternalDonationCreatorService
  class << self
    def call(data)
      return if data.blank?

      donation = create_donation(data)
      create_external_donation(donation, data)
    rescue StandardError => e
      Rails.logger.error "#{donation_class} creation error: #{e}\n#{e.backtrace}"
      nil
    end

    private

    # Abstract methods
    # :nocov:
    def size(data)
      raise NotImplementedError
    end

    def date(data)
      raise NotImplementedError
    end

    def message(data)
      raise NotImplementedError
    end

    def vk_user_external_id(data)
      raise NotImplementedError
    end

    def external_id(data)
      raise NotImplementedError
    end

    def donation_class
      raise NotImplementedError
    end
    # :nocov:

    def create_donation(data)
      DonationCreatorService.call(size(data), date(data), message(data) || '')
    end

    def create_external_donation(donation, data)
      donation_class.create!(
        donation: donation,
        message: message(data),
        vk_user_external_id: vk_user_external_id(data),
        external_id: external_id(data)
      )
    end
  end
end

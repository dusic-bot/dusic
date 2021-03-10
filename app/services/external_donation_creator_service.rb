# frozen_string_literal: true

class ExternalDonationCreatorService
  DONATION_IDENTIFIERS_REGEX = /([a-zA-Z]+_[a-zA-Z]+)/.freeze

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
      size = size(data)
      date = date(data)
      server, user = get_server_and_user(message(data) || '')

      Donation.create!(size: size, date: date, discord_server_id: server&.id, discord_user_id: user&.id)
    end

    def create_external_donation(donation, data)
      donation_class.create!(
        donation: donation,
        message: message(data),
        vk_user_external_id: vk_user_external_id(data),
        external_id: external_id(data)
      )
    end

    def get_server_and_user(message)
      donation_identifiers = message.match(DONATION_IDENTIFIERS_REGEX)
      return [nil, nil] if donation_identifiers.blank?

      user_external_id, server_external_id = DonationIdDecoderService.call(donation_identifiers.captures.first)
      server = DiscordServer.find_or_create_by(external_id: server_external_id)
      user = DiscordUser.find_or_create_by(external_id: user_external_id)
      [server, user]
    rescue StandardError => e
      Rails.logger.error "#{donation_class} server and/or user creation error: #{e}\n#{e.backtrace}"
      [nil, nil]
    end
  end
end

# frozen_string_literal: true

class DonationCreatorService
  DONATION_IDENTIFIERS_REGEX = /([a-zA-Z]+_[a-zA-Z]+)/.freeze

  class << self
    def call(size, date, message)
      server, user = get_server_and_user(message)

      Donation.create!(size: size, date: date, discord_server_id: server&.id, discord_user_id: user&.id)
    end

    private

    def get_server_and_user(message)
      donation_identifiers = message.match(DONATION_IDENTIFIERS_REGEX)
      return [nil, nil] if donation_identifiers.blank?

      user_external_id, server_external_id = DonationIdDecoderService.call(donation_identifiers.captures.first)
      server = DiscordServer.find_or_create_by(external_id: server_external_id)
      user = DiscordUser.find_or_create_by(external_id: user_external_id)
      [server, user]
    rescue StandardError => e
      Rails.logger.error "Donation server and/or user creation error: #{e}\n#{e.backtrace}"
      [nil, nil]
    end
  end
end

# frozen_string_literal: true

class DonationCreatorService
  DONATION_IDENTIFIERS_REGEX = /([a-zA-Z]+_[a-zA-Z]+)/.freeze

  class << self
    def call(size, date, message, previous_donations_query: nil)
      server_id, user_id = get_server_and_user_ids(message)

      if server_id.nil? && user_id.nil?
        server_id, user_id = get_server_and_user_ids_based_on_previous_donations(previous_donations_query)
      end

      Donation.create!(size: size, date: date, discord_server_id: server_id, discord_user_id: user_id)
    end

    private

    def get_server_and_user_ids(message)
      donation_identifiers = message.match(DONATION_IDENTIFIERS_REGEX)
      return [nil, nil] if donation_identifiers.blank?

      user_external_id, server_external_id = DonationIdDecoderService.call(donation_identifiers.captures.first)
      server = DiscordServer.find_or_create_by(external_id: server_external_id)
      user = DiscordUser.find_or_create_by(external_id: user_external_id)
      [server.id, user.id]
    rescue StandardError => e
      Rails.logger.error "Donation server and/or user creation error: #{e}\n#{e.backtrace}"
      [nil, nil]
    end

    def get_server_and_user_ids_based_on_previous_donations(previous_donations_query)
      return [nil, nil] if previous_donations_query.nil?

      previous_donation =
        previous_donations_query
        .where('discord_server_id IS NOT NULL AND discord_user_id IS NOT NULL')
        .order(created_at: :desc).first

      [previous_donation&.discord_server_id, previous_donation&.discord_user_id]
    end
  end
end

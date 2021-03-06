# frozen_string_literal: true

class VkdonateDonationCreatorService
  DONATION_IDENTIFIERS_REGEX = /([a-zA-Z]+_[a-zA-Z]+)/.freeze

  class << self
    def call(data)
      return if data.nil?

      donation = create_donation(data)
      create_vkdonate_donation(donation, data)
    rescue StandardError => e
      Rails.logger.error "Vkdonate donation creation error: #{e}\n#{e.backtrace}"
      nil
    end

    private

    def create_donation(data)
      size = data.sum
      date = data.date
      server, user = get_server_and_user(data.message || '')

      Donation.create!(size: size, date: date, discord_server_id: server&.id, discord_user_id: user&.id)
    end

    def create_vkdonate_donation(donation, data)
      VkdonateDonation.create!(
        donation: donation,
        message: data.message,
        vk_user_external_id: data.uid,
        external_id: data.id
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
      Rails.logger.error "Vkdonate donation server and/or user creation error: #{e}\n#{e.backtrace}"
      [nil, nil]
    end
  end
end

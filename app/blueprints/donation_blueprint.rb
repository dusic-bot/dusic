# frozen_string_literal: true

class DonationBlueprint < Blueprinter::Base
  identifier :id

  field :size
  field :date
  field :discord_user_external_id do |donation|
    donation.discord_user&.external_id
  end
  field :discord_server_external_id do |donation|
    donation.discord_server&.external_id
  end
end

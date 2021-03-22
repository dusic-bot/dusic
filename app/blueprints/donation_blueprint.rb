# frozen_string_literal: true

class DonationBlueprint < Blueprinter::Base
  identifier :id

  field :size
  field :date
  field :user_id do |donation|
    donation.discord_user&.external_id
  end
  field :server_id do |donation|
    donation.discord_server&.external_id
  end
end

# frozen_string_literal: true

class Donation < ApplicationRecord
  belongs_to :discord_server, optional: true
  belongs_to :discord_user, optional: true

  validates :date, presence: true
  validates :size, numericality: { greater_than_or_equal_to: 0 }

  after_create { |record| NewDonationBroadcasterService.call(record) }
end

# frozen_string_literal: true

class DailyStatistic < ApplicationRecord
  belongs_to :discord_server

  validates :date, presence: true
  validates :tracks_length, numericality: { greater_than_or_equal_to: 0 }
  validates :tracks_amount, numericality: { greater_than_or_equal_to: 0 }
end

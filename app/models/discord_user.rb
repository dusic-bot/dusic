# frozen_string_literal: true

class DiscordUser < ApplicationRecord
  validates :external_id, numericality: { greater_than: 0 }
end

# frozen_string_literal: true

class DiscordUser < ApplicationRecord
  validates :external_id, presence: true
end

# frozen_string_literal: true

class DiscordServer < ApplicationRecord
  def dm?
    external_id.zero?
  end
end

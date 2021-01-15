# frozen_string_literal: true

class Donation < ApplicationRecord
  validates :size, numericality: { greater_than_or_equal_to: 0 }
end

# frozen_string_literal: true

class Setting < ApplicationRecord
  belongs_to :discord_server

  validates :language, presence: true, inclusion: { in: %w[ru en] }
  validates :volume, numericality: { greater_than: 0, less_than_or_equal_to: 1000 }
  validate :prefix_is_correct

  private

  def prefix_is_correct
    return if prefix.nil?

    errors.add(:prefix, 'can not be blank for regular server') if prefix.empty? && !discord_server.dm?
    errors.add(:prefix, 'have bad format') unless prefix.match?(/^\S{0,64}$/)
  end
end

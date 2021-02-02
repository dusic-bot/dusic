# frozen_string_literal: true

class DiscordServer < ApplicationRecord
  has_one :setting, dependent: :destroy
  has_one :statistic, dependent: :destroy

  has_many :daily_statistics, dependent: :destroy
  has_many :donations, dependent: :nullify

  has_one :today_statistic, -> { where(date: Time.zone.today) },
          class_name: 'DailyStatistic',
          inverse_of: :discord_server

  def dm?
    external_id.zero?
  end
end

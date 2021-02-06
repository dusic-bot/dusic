# frozen_string_literal: true

class DiscordServer < ApplicationRecord
  has_one :setting, dependent: :destroy
  has_one :statistic, dependent: :destroy

  has_many :daily_statistics, dependent: :destroy
  has_many :donations, dependent: :nullify

  has_one :today_statistic, -> { where(date: Time.zone.today) },
          class_name: 'DailyStatistic',
          inverse_of: :discord_server
  has_one :last_donation, -> { order(date: :desc).limit(1) },
          class_name: 'Donation',
          inverse_of: :discord_server

  after_create :create_setting, :create_statistic

  def dm?
    external_id.zero?
  end
end

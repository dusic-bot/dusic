# frozen_string_literal: true

class DiscordServerBlueprint < Blueprinter::Base
  identifier :external_id, name: 'id'

  association :setting, blueprint: SettingBlueprint
  association :statistic, blueprint: StatisticBlueprint
  association :today_statistic, blueprint: DailyStatisticBlueprint do |discord_server|
    discord_server.today_statistic || DailyStatistic.new(date: Time.zone.today)
  end
  association :last_donation, blueprint: DonationBlueprint
end

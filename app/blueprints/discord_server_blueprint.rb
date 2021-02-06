# frozen_string_literal: true

class DiscordServerBlueprint < Blueprinter::Base
  identifier :id

  association :setting, blueprint: SettingBlueprint
  association :statistic, blueprint: StatisticBlueprint
  association :today_statistic, blueprint: DailyStatisticBlueprint
  association :last_donation, blueprint: DonationBlueprint
end

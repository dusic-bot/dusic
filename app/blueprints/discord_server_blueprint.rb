# frozen_string_literal: true

class DiscordServerBlueprint < Blueprinter::Base
  identifier :external_id, name: 'id'

  association :setting, blueprint: SettingBlueprint
  association :statistic, blueprint: StatisticBlueprint
  association :today_statistic, blueprint: DailyStatisticBlueprint, default: DailyStatisticBlueprint::EMPTY
  association :last_donation, blueprint: DonationBlueprint
end

# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    discord_server
    dj_role { nil }
    language { 'ru' }
    autopause { true }
    volume { 100 }
    prefix { nil }
  end
end

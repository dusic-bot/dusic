# frozen_string_literal: true

FactoryBot.define do
  factory :daily_statistic do
    discord_server
    date { Date.current }
    tracks_length { 0 }
    tracks_amount { 0 }
  end
end

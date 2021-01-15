# frozen_string_literal: true

FactoryBot.define do
  factory :statistic do
    discord_server
    tracks_length { 0 }
    tracks_amount { 0 }
  end
end

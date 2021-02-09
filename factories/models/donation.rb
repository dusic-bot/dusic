# frozen_string_literal: true

FactoryBot.define do
  factory :donation do
    size { 10 }
    date { Time.current }
    discord_server
    discord_user
  end
end

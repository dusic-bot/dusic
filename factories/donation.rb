# frozen_string_literal: true

FactoryBot.define do
  factory :donation do
    size { 10 }
    date { Time.current }
    discord_server_external_id { nil }
    discord_user_external_id { nil }
  end
end

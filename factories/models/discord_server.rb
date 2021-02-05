# frozen_string_literal: true

FactoryBot.define do
  factory :discord_server do
    sequence(:external_id) { |n| 482473013246296084 + n }

    trait :dm do
      external_id { 0 }
    end
  end
end

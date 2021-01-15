# frozen_string_literal: true

FactoryBot.define do
  factory :discord_server do
    external_id { 482473013246296084 }

    trait :dm do
      external_id { 0 }
    end
  end
end

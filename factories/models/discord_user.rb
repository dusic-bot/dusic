# frozen_string_literal: true

FactoryBot.define do
  factory :discord_user do
    sequence(:external_id) { |n| 208117693537058817 + n }
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :vkponchik_donation do
    donation
    message { nil }
    vk_user_external_id { 1 }
    sequence(:external_id) { |n| 100 + n }
  end
end

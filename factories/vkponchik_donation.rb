# frozen_string_literal: true

FactoryBot.define do
  factory :vkponchik_donation do
    donation
    message { nil }
    vk_user_external_id { 1 }
    external_id { 1 }
  end
end

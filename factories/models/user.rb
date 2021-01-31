# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'test@email.com' }
    password { 'password' }
    admin { false }
  end
end

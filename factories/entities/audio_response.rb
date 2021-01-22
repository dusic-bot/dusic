# frozen_string_literal: true

FactoryBot.define do
  factory :audio_response do
    request_type { :find }
    response { 'stub' }

    initialize_with { new(request_type, response) }
  end
end

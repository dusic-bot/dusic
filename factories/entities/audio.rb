# frozen_string_literal: true

FactoryBot.define do
  factory :audio do
    external { 'stub' }
    id { '1_0_a_b' }

    initialize_with { new(external, id) }
  end
end

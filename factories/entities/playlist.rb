# frozen_string_literal: true

FactoryBot.define do
  factory :playlist do
    external { 'stub' }
    manager { :vk }
    id { '1_0_a' }
    audios { [] }

    initialize_with { new(external, manager, id, audios) }
  end
end

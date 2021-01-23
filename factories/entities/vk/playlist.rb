# frozen_string_literal: true

FactoryBot.define do
  factory :vk_playlist, class: Vk::Playlist do
    external { 'stub' }
    id { '1_0_a' }
    audios { [] }

    initialize_with { new(external, id, audios) }
  end
end

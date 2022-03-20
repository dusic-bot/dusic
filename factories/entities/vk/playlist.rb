# frozen_string_literal: true

FactoryBot.define do
  factory :vk_playlist, class: Vk::Playlist do
    external { 'stub' }
    id { '1_0_a' }
    audios { [] }

    initialize_with { new(external, id, audios) }

    trait :with_vk_music_external do
      transient do
        title { 'title' }
        subtitle { 'subtitle' }
        external_audios { [] }
      end

      external { VkMusic::Playlist.new(external_audios, title:, subtitle:) }
    end
  end
end

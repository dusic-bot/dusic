# frozen_string_literal: true

FactoryBot.define do
  factory :vk_audio, class: Vk::Audio do
    external { 'stub' }
    id { '1_0_a_b' }

    initialize_with { new(external, id) }

    trait :with_vk_music_external do
      transient do
        artist { 'artist' }
        title { 'title' }
        duration { 60 }
      end

      external { VkMusic::Audio.new(artist:, title:, duration:) }
    end
  end
end

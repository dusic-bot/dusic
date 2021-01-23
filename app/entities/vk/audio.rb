# frozen_string_literal: true

class Vk::Audio < Audio
  delegate :artist, :title, :duration, to: :external
end

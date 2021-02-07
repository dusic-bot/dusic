# frozen_string_literal: true

class AudioBlueprint < Blueprinter::Base
  field :id
  field :manager do |audio, _options|
    case audio
    when Vk::Audio then 'vk'
    end
  end

  field :artist
  field :title
  field :duration
end

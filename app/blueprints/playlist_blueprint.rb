# frozen_string_literal: true

class PlaylistBlueprint < Blueprinter::Base
  field :id
  field :manager do |audio, _options|
    case audio
    when Vk::Playlist then 'vk'
    end
  end
end

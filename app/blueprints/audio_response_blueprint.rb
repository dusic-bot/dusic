# frozen_string_literal: true

class AudioResponseBlueprint < Blueprinter::Base
  field :request_type

  field :response do |audio_response, _options|
    audio_response.response.map do |item|
      case item
      when Playlist then PlaylistBlueprint.render_as_json(item)
      when Audio then AudioBlueprint.render_as_json(item)
      end
    end
  end
end

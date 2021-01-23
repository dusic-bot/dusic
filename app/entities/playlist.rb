# frozen_string_literal: true

class Playlist
  attr_reader :id, :external, :audios

  def initialize(external, id, audios)
    @external = external
    @id = id
    @audios = audios
  end
end

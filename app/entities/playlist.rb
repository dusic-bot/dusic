# frozen_string_literal: true

require 'delegate'

class Playlist < SimpleDelegator
  attr_accessor :manager, :id, :external, :audios

  def initialize(external, manager, id, audios)
    @external = external
    @manager = manager
    @id = id
    @audios = audios

    super(@external)
  end
end

# frozen_string_literal: true

require 'delegate'

class Playlist < SimpleDelegator
  attr_accessor :manager, :id, :external

  def initialize(external, manager, id)
    @external = external
    @manager = manager
    @id = id

    super(@external)
  end
end

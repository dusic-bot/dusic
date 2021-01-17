# frozen_string_literal: true

require 'delegate'

class Audio < SimpleDelegator
  attr_accessor :external, :manager, :id

  def initialize(external, manager, id)
    @external = external
    @manager = manager
    @id = id

    super(@external)
  end
end

# frozen_string_literal: true

class Audio
  attr_reader :external, :id

  def initialize(external, id)
    @external = external
    @id = id
  end
end

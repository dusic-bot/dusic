# frozen_string_literal: true

class Audio
  attr_reader :external, :id

  def initialize(external, id)
    @external = external
    @id = id
  end

  def artist
    raise NotImplementedError
  end

  def title
    raise NotImplementedError
  end

  def duration
    raise NotImplementedError
  end

  def duration_str
    return @duration_str if defined?(@duration_str)

    seconds = duration % 60
    minutes = (duration / 60) % 60
    hours = duration / (60 * 60)

    @duration_str = format('%<h>02d:%<m>02d:%<s>02d', h: hours, m: minutes, s: seconds)
  end
end

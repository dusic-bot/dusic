# frozen_string_literal: true

class AudioManager
  def request(type, query)
    raise NotImplementedError
  end

  def initialize; end
end

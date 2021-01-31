# frozen_string_literal: true

class AudioResponse
  attr_accessor :request_type, :response

  def initialize(request_type, response)
    @request_type = request_type
    @response = response
  end

  def empty?
    request_type.nil? || response.nil?
  end

  def self.empty
    new(nil, nil)
  end
end

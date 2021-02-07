# frozen_string_literal: true

require 'jwt'

class JwtEncoderService
  def self.call(payload)
    JWT.encode(payload, Rails.application.credentials[:hmac_secret], 'HS512')
  end
end

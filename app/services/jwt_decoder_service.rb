# frozen_string_literal: true

require 'jwt'

class JwtDecoderService
  def self.call(token)
    body = JWT.decode(token, Rails.application.credentials[:hmac_secret], true, algorithm: 'HS512')

    # NOTE: Second element is hash with metadata
    HashWithIndifferentAccess.new(body.first)
  rescue JWT::DecodeError
    nil
  end
end

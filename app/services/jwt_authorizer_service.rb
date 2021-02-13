# frozen_string_literal: true

class JwtAuthorizerService
  def self.call(token, access_level:)
    body = JwtDecoderService.call(token)

    return false if body.blank?

    body['access_level'].is_a?(Integer) && body['access_level'] >= access_level
  rescue StandardError
    false
  end
end

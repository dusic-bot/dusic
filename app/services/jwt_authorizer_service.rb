# frozen_string_literal: true

class JwtAuthorizerService
  def self.call(token, controller:)
    body = JwtDecoderService.call(token)
    return false if body.blank?

    allowed_controllers = body['access']['controllers']
    allowed_controllers.is_a?(Array) && allowed_controllers.include?(controller)
  rescue StandardError
    false
  end
end

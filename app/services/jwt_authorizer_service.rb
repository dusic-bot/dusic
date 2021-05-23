# frozen_string_literal: true

class JwtAuthorizerService
  # TODO: Get read of 'access_level' field check
  def self.call(token, controller:)
    body = JwtDecoderService.call(token)
    return false if body.blank?

    # DEPRECATED: Use access object instead
    return body['access_level'] >= 1 if body['access_level'].is_a?(Integer)

    allowed_controllers = body['access']['controllers']
    allowed_controllers.is_a?(Array) && allowed_controllers.include?(controller)
  rescue StandardError
    false
  end
end

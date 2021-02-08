# frozen_string_literal: true

class JwtAuthorizerService
  def self.call(request, access_level:)
    token = request.headers['Authorization'].to_s.delete_prefix('Bearer ')
    body = JwtDecoderService.call(token)

    return false if body.blank?

    body['access_level'].is_a?(Integer) && body['access_level'] >= access_level
  rescue StandardError
    false
  end
end

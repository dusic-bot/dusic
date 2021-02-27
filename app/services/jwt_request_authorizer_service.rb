# frozen_string_literal: true

class JwtRequestAuthorizerService
  def self.call(request, **options)
    return false if request&.headers.blank?

    token = request.headers['Authorization'].to_s.delete_prefix('Bearer ')
    JwtAuthorizerService.call(token, **options)
  end
end

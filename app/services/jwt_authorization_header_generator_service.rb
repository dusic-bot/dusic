# frozen_string_literal: true

class JwtAuthorizationHeaderGeneratorService
  def self.call(access_level: 0)
    "Bearer #{JwtEncoderService.call(access_level: access_level)}"
  end
end

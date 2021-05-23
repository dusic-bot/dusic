# frozen_string_literal: true

class JwtAuthorizationHeaderGeneratorService
  def self.call(**options)
    "Bearer #{JwtEncoderService.call(**options)}"
  end
end

# frozen_string_literal: true

class JwtAuthorizationHeaderGeneratorService
  def self.call(**)
    "Bearer #{JwtEncoderService.call(**)}"
  end
end

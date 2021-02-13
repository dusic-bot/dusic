# frozen_string_literal: true

class Api::V2Controller < ApiController
  before_action :authenticate

  private

  def authenticate
    head :unauthorized unless JwtRequestAuthorizerService.call(request, access_level: 1)
  end
end

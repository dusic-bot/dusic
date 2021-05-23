# frozen_string_literal: true

class Api::V2Controller < ApiController
  before_action :authenticate

  private

  def authenticate
    head :unauthorized unless JwtRequestAuthorizerService.call(request, **authentication_options)
  end

  # Abstract methods
  # :nocov:
  def authentication_options
    raise NotImplementedError
  end
  # :nocov:
end

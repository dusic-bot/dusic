# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  def admin_check
    return if current_user&.admin

    redirect_to main_app.root_path, alert: 'Access denied'
  end
end

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale

  private

  def switch_locale(&action)
    locale = params[:locale] || cookies[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def admin_check
    return if current_user&.admin

    redirect_to main_app.root_path, alert: 'Access denied'
  end
end

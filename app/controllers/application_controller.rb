# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  after_action :set_response_language_header

  private

  def switch_locale(&action)
    # NOTE: i18n authors think that using cookies for storing locale is an anti-pattern, but I personally disagree
    locale = params[:locale] || cookies[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def set_response_language_header
    response.headers['Content-Language'] = I18n.locale.to_s
  end

  def admin_check
    return if current_user&.admin

    redirect_to main_app.root_path, alert: 'Access denied'
  end
end

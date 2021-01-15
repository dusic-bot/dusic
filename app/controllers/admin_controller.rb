# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :admin_check

  private

  def admin_check
    return if current_user&.admin

    redirect_to root_path, alert: 'Access denied'
  end
end

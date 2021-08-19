# frozen_string_literal: true

class AdminController < ApplicationController
  layout 'admin_application'

  before_action :admin_check
end

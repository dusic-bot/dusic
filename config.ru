# This file is used by Rack-based servers to start the application.

RAILS_SERVER = true

require_relative 'config/environment'

run Rails.application
Rails.application.load_server

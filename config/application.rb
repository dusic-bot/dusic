require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dusic
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"

    config.eager_load_paths << Rails.root.join('app', 'services')
    config.eager_load_paths << Rails.root.join('app', 'entities')
    config.eager_load_paths << Rails.root.join('app', 'queries')
    config.eager_load_paths << Rails.root.join('app', 'blueprints')

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Default locale
    config.i18n.default_locale = :ru

    # Available locales
    config.i18n.available_locales = %i[ru en]

    # Locale directories
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  end
end

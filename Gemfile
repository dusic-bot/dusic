source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# Authentication
gem 'devise'

# DB administrating
gem 'rails_admin'

# VK music
gem 'vk_music', '>= 4.1.2'

# Small gem for calling same method from time to time
gem 'handling_queue'

# Font awesome icons
gem 'font-awesome-rails'

# Models serialization
gem 'blueprinter'

# JSON web token authentication
gem 'jwt'

# Vkponchik donations
gem 'vkponchik', '~> 1.1'

# Vkdonate donations
gem 'vkdonate'

# DB queries
gem 'blazer'

# Sitemap generation
gem 'sitemap_generator'

# Former default gems
gem 'net-imap', require: false
gem 'net-pop', require: false
gem 'net-smtp', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Code quality
  gem 'rubocop', require: false
  # Rubocop Rails extension
  gem 'rubocop-rails', require: false
  # Rubocop Rake extension
  gem 'rubocop-rake', require: false
  # Rubocop performance extension
  gem 'rubocop-performance', require: false
  # Rubocop RSpec extension
  gem 'rubocop-rspec', require: false

  # Bring cops into erb
  gem 'erb_lint', require: false

  # Specification and testing
  gem 'rspec', require: false
  # RSpec for RoR
  gem 'rspec-rails', require: false
  # RSpec controller testing
  gem 'rails-controller-testing', require: false

  # Time travelling in tests
  gem 'timecop'

  # Code coverage
  gem 'simplecov'

  # Fixtures
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Deploying
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

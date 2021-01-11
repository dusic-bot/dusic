# Rails
require_relative 'config/application'
Rails.application.load_tasks

# Rubocop
require 'rubocop/rake_task'
RuboCop::RakeTask.new

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

# Default
task default: %i[rubocop spec]

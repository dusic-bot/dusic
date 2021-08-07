# frozen_string_literal: true

# rubocop:disable Rails/RakeEnvironment

desc 'Run ERB check'
task :erblint do
  puts 'Running erblint...'
  abort('erblint failed!') unless system('erblint app/views/*')
  puts
end

# rubocop:enable Rails/RakeEnvironment

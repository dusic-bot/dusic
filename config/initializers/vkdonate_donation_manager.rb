# frozen_string_literal: true

Rails.configuration.after_initialize do
  Rails.logger.info 'Initializing Vkdonate Donation Manager'
  credentials = Rails.application.credentials.donations[:vkdonate]

  VKDONATE_CLIENT = Vkdonate::Client.new(credentials[:api_key]) # rubocop:disable Lint/ConstantDefinitionInBlock

  if defined?(RAILS_SERVER)
    VkdonateDonationsCheckJob.set(wait: 25.seconds).perform_later
  else
    Rails.logger.debug 'Vkdonate donations check job disabled in non-server environment'
  end
end

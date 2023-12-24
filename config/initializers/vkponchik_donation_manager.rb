# frozen_string_literal: true

Rails.configuration.after_initialize do
  Rails.logger.info 'Initializing Vkponchik Donation Manager'
  credentials = Rails.application.credentials.donations[:vkponchik]

  VKPONCHIK_CLIENT = Vkponchik::Client.new(credentials[:group_id], credentials[:api_key]) # rubocop:disable Lint/ConstantDefinitionInBlock

  if defined?(RAILS_SERVER)
    VkponchikDonationsCheckJob.set(wait: 15.seconds).perform_later
  else
    Rails.logger.debug 'Vkponchik donations check job disabled in non-server environment'
  end
end

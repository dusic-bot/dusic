# frozen_string_literal: true

Rails.configuration.after_initialize do
  Rails.logger.info 'Initializing Vkponchik Donation Manager'
  credentials = Rails.application.credentials.donations[:vkponchik]

  ::VKPONCHIK_CLIENT = Vkponchik::Client.new(credentials[:group_id], credentials[:api_key])

  VkponchikDonationsCheckJob.set(wait: 15.seconds).perform_later
end

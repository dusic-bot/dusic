# frozen_string_literal: true

Rails.configuration.after_initialize do
  Rails.logger.info 'Initializing Vkdonate Donation Manager'
  credentials = Rails.application.credentials.donations[:vkdonate]

  ::VKDONATE_CLIENT = Vkdonate::Client.new(credentials[:api_key])

  VkponchikDonationsCheckJob.set(wait: 25.seconds).perform_later unless Rails.env.test?
end

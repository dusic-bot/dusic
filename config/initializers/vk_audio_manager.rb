# frozen_string_literal: true

Rails.configuration.after_initialize do
  Rails.logger.info 'Initializing VK Audio Manager'
  credentials = Rails.application.credentials.vk

  ::VK_AUDIO_MANAGER = Vk::AudioManager.new(credentials[:login], credentials[:password]) unless Rails.env.test?
end

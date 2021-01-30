# frozen_string_literal: true

class AudioLoaderService
  FORMATS = {
    vk: :m3u8url
  }.freeze

  class << self
    def call(params)
      format = params[:format].presence&.to_sym
      manager = params[:manager].presence&.to_sym
      id = params[:id]
      return if manager.nil? || id.blank?

      url = get_url(manager, id)
      return if url.blank?

      get_io(url, manager, format)
    end

    private

    def get_url(manager, id)
      case manager
      when :vk then VK_AUDIO_MANAGER.url(Vk::Audio.new(nil, id))
      end
    end

    def get_io(url, manager, format = nil)
      io = StringIO.new(url)

      initial_format = FORMATS[manager]
      FormatConverterService.call(io, initial_format, format || initial_format)
    end
  end
end

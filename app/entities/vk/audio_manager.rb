# frozen_string_literal: true

require 'vk_music'
require 'handling_queue'

module Vk
  class AudioManager < ::AudioManager
    TYPES = %i[auto playlist audios wall post find artist].freeze

    def request(type, query)
      type = guess_type(query) if type == :auto
      return AudioResponse.empty unless TYPES.include?(type)

      AudioResponse.new(type, fetch_data(type, query))
    end

    def initialize(login, password)
      @client = VkMusic::Client.new(login: login, password: password)

      @url_handler = HandlingQueue.new(slice: 10, interval: 2) do |arr|
        ids = arr.map(&:obj)
        audios = @client.get_urls(ids)
        Rails.logger.debug "Fetched #{audios.compact.size}/#{audios.size} audios"
        a.each.with_index { |e, i| e.re = audios[i] }
      end

      super()
    end

    private

    def guess_type(arg)
      VkMusic::Utility::DataTypeGuesser.call(arg)
    end

    # @return [Audio, Playlist, Array<Audio>]
    def fetch_data(type, query)
      case type
      when :playlist then playlist(query)
      when :audios then audios(query)
      when :wall then wall(query)
      when :post then post(query)
      when :find then find(query)
      when :artist then artist(query)
      end
    end

    def playlist(url)
      vk_request_wrap { @client.playlist(url: url) }
    end

    def audios(url)
      vk_request_wrap { @client.audios(url: url) }
    end

    def wall(url)
      vk_request_wrap { @client.wall(url: url) }
    end

    def post(url)
      vk_request_wrap { @client.post(url: url) }
    end

    def find(query)
      vk_request_wrap { @client.find(query) }
    end

    def artist(url)
      vk_request_wrap { @client.artist(url: url) }
    end

    def vk_request_wrap
      convert_all(yield).compact
    rescue StandardError => e
      Rails.logger.error("VK audio convertion error: #{e}\n#{e.backtrace}")
      []
    end

    def convert_all(data)
      if data.is_a? Array
        data.map { |el| convert_single(el) }.compact
      elsif data.nil?
        []
      else
        [convert_single(data)]
      end
    end

    def convert_single(data)
      case data
      when VkMusic::Audio then convert_audio(data)
      when VkMusic::Playlist then convert_playlist(data)
      else
        Rails.logger.error("Failed to convert object returned by VK lib: #{data}")
        nil
      end
    end

    def convert_audio(audio)
      Vk::Audio.new(audio, audio.full_id)
    end

    def convert_playlist(playlist)
      id = [playlist.owner_id, playlist.id, playlist.access_hash].join('_')

      audios = playlist.map { |e| convert_single(e) }
      audios.compact!

      Vk::Playlist.new(playlist, id, audios)
    end
  end
end

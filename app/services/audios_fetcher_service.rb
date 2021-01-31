# frozen_string_literal: true

class AudiosFetcherService
  def self.call(params)
    case params[:manager]&.to_sym
    when :vk
      VK_AUDIO_MANAGER.request(params[:type]&.to_sym, params[:query].to_s)
    else
      AudioResponse.empty
    end
  end
end

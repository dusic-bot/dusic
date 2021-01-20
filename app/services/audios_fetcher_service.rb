# frozen_string_literal: true

class AudiosFetcherService
  def self.call(params)
    case params[:manager]&.to_sym
    when :vk then VK_AUDIO_MANAGER.request(params[:type], params[:query])
    else
      AudioResponse.empty
    end
  end
end

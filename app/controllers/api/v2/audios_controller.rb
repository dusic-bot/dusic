# frozen_string_literal: true

class Api::V2::AudiosController < Api::V2Controller
  def index
    audios_params = params.permit(:manager, :type, :query)
    audio_response = AudiosFetcherService.call(audios_params)

    render json: AudioResponseBlueprint.render(audio_response)
  end

  def show
    audio_params = params.permit(:manager, :id, :format)
    io = AudioLoaderService.call(audio_params)
    return head :not_found if io.nil?

    send_data io.read, filename: "#{audio_params[:manager]}#{audio_params[:id]}.#{audio_params[:format]}"
  end
end

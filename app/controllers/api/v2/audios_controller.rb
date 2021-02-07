# frozen_string_literal: true

class Api::V2::AudiosController < Api::V2Controller
  def index
    audios_params = params.permit(:manager, :type, :query)
    audio_response = AudiosFetcherService.call(audios_params)

    render json: AudioResponseBlueprint.render(audio_response)
  end

  def show
    # TODO
  end
end

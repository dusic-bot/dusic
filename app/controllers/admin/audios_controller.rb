# frozen_string_literal: true

class Admin::AudiosController < AdminController
  def index
    @audios = []
    return if params[:audios].blank?

    audios_params = params.require(:audios).permit(:manager, :type, :query)
    @audios = AudiosFetcherService.call(audios_params).response
  end

  def show
    audio_params = params.permit(:manager, :id, :format)
    io = AudioLoaderService.call(audio_params)
    return head :not_found if io.nil?

    send_data io.read, filename: "#{audio_params[:manager]}#{audio_params[:id]}.#{audio_params[:format]}"
  end
end

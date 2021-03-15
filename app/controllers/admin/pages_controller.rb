# frozen_string_literal: true

class Admin::PagesController < AdminController
  def root; end

  def donation_id
    return if params[:donation].blank?

    donation_params = params.require(:donation).permit(:id, :user_id, :server_id)
    @id, @user_id, @server_id = DonationIdDataFillerService.call(donation_params)
    flash.alert = 'Wrong arguments specified' if @id.blank?
  end

  def jwt_token
    return if params[:payload].nil?

    payload = JSON.parse(params[:payload].to_s)
    @token = JwtEncoderService.call(payload)
  rescue JSON::ParserError
    flash.alert = 'JSON parsing error! Specify correct payload'
  end

  def audios
    @audios = []
    return if params[:audios].blank?

    audios_params = params.require(:audios).permit(:manager, :type, :query)
    @audios = AudiosFetcherService.call(audios_params).response
  end

  def audio
    return head :not_found if params[:audio].blank?

    audio_params = params.require(:audio).permit(:manager, :id, :format)
    io = AudioLoaderService.call(audio_params)
    return head :not_found if io.nil?

    send_data io.read, filename: "#{audio_params[:manager]}#{audio_params[:id]}.#{audio_params[:format]}"
  end

  def websocket_server
    return if params[:websocket_server].blank?

    websocket_params = params.require(:websocket_server).permit(:action, clients: [])
    WebsocketServerOrdererService.call(websocket_params[:action], websocket_params[:clients])
  end

  def donation_adder
    return if params[:donation].blank?

    donation_params = params.require(:donation).permit(:message, :size, :date)
    DonationAdderService.call(donation_params)
    flash.notice = 'Donation created'
  rescue Date::Error
    flash.alert = 'Please specify correct date!'
  end
end

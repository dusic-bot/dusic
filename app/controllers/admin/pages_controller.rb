# frozen_string_literal: true

class Admin::PagesController < AdminController
  def root; end

  def donation_id
    return if params[:donation].blank?

    donation_params = params.require(:donation).permit(:id, :user_id, :server_id)
    @id, @user_id, @server_id = DonationIdDataFillerService.call(donation_params)
    flash.alert = 'Wrong arguments specified' if @id.blank?
  end

  def audios
    @audios = []
    return if params[:audios].blank?

    audios_params = params.require(:audios).permit(:manager, :type, :query)
    @audios = AudiosFetcherService.call(audios_params).response
  end
end

# frozen_string_literal: true

class Admin::PagesController < AdminController
  def root; end

  def donation_id; end

  def donation_id_convert
    donation_params = params.require(:donation).permit(:id, :user_id, :server_id)
    @id, @user_id, @server_id = DonationIdDataFillerService.call(donation_params)
    flash.alert = 'Wrong arguments specified' if @id.blank?
    render 'donation_id'
  end
end

# frozen_string_literal: true

class DonationAdderService
  def self.call(params)
    DonationCreatorService.call(
      params[:size].to_i,
      Date.parse(params[:date].to_s).beginning_of_day,
      params[:message].to_s
    )
  end
end

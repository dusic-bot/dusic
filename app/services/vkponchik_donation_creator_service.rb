# frozen_string_literal: true

class VkponchikDonationCreatorService
  def self.call(data)
    # TODO
    # { 'id' => '1', 'date' => '1610498453676', 'amount' => '1', 'user' => '157230821', 'msg' => 'message' }
    #
    # Rails.logger.info "New Vkponchik donation: #{donation}"
    # m = donation['msg']&.match(/[a-zA-Z]+_[a-zA-Z]+/)
    # ids = m ? VkponchikDonationManager.decode_donator_id(m[0]) : []
    # h = {
    #   id: donation['id'],
    #   message: donation['msg'] || '',
    #   vk_user_id: donation['user'],
    #   date: Time.at(donation['date'].to_i / 1000).to_datetime,
    #   user_id: ids[0] || nil,
    #   server_id: ids[1] || nil,
    #   size: donation['amount']
    # }
    # VkponchikDonation.create_from_data(h)
  end
end

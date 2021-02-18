# frozen_string_literal: true

class NewDonationStreamerService
  def self.call(donation)
    ActionCable.server.broadcast 'donations/create', **DonationBlueprint.render_as_hash(donation)
  end
end

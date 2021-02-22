# frozen_string_literal: true

class NewDonationBroadcasterService
  def self.call(donation)
    ActionCable.server.broadcast 'donations/create', **DonationBlueprint.render_as_hash(donation)
  end
end

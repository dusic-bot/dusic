# frozen_string_literal: true

class NewDonationBroadcasterService
  def self.call(donation)
    # NOTE: Action cable formats hash with `JSON.encode`, which results in different datetime format.
    #   This is currently avoided with using `render` and then parsing generated string.
    json_encoded = DonationBlueprint.render(donation)
    ActionCable.server.broadcast 'donations/create', **JSON.parse(json_encoded)
  end
end

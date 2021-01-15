# frozen_string_literal: true

require 'alphabet_encoding'

class DonationIdDecoderService
  def self.call(donation_id)
    user_part, server_part = donation_id.split('_')
    [AlphabetEncoding.decode(user_part), AlphabetEncoding.decode(server_part)]
  end
end

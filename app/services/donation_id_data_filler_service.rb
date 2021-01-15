# frozen_string_literal: true

require 'alphabet_encoding'

class DonationIdDataFillerService
  class << self
    def call(params)
      if params[:id].present?
        id = params[:id]
        user_id, server_id = DonationIdDecoderService.call(id)
      elsif params[:user_id].present? && params[:server_id].present?
        user_id = params[:user_id]
        server_id = params[:server_id]
        id = encode(user_id, server_id)
      end

      [id, user_id, server_id]
    end

    private

    def encode(user_id, server_id)
      "#{AlphabetEncoding.encode(user_id)}_#{AlphabetEncoding.encode(server_id)}"
    end
  end
end

# frozen_string_literal: true

module Api
  module V2
    class DonationsChannel < ApplicationCable::Channel
      def subscribed
        stream_from 'donations/create'
      end
    end
  end
end

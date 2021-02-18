# frozen_string_literal: true

module Api
  module V2
    class ShardsChannel < ApplicationCable::Channel
      def subscribed
        stream_from 'shards'
        stream_from "shards/#{current_shard.identifier}"
      end
    end
  end
end

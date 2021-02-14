# frozen_string_literal: true

module Api
  module V2
    class ShardsChannel < ApplicationCable::Channel
      def subscribed
        stream_from 'shards'
        stream_from "shards/#{current_shard.shard_id}_#{current_shard.shard_num}_#{current_shard.bot_id}"
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V2
    class ShardsChannel < ApplicationCable::Channel
      def subscribed
        stream_from 'shards'
        stream_from "shards/#{current_shard.identifier}"
      end

      def connection_data(raw_data)
        current_shard.servers_count = raw_data['servers_count'].to_i
        current_shard.cached_servers_count = raw_data['cached_servers_count'].to_i
        current_shard.active_servers_count = raw_data['active_servers_count'].to_i
      end
    end
  end
end

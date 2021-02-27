# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_shard

    def connect
      setup_shard_data
      authorize_shard
    end

    private

    def setup_shard_data
      params = request.params

      token = params[:token].to_s
      shard_id = params[:shard_id].to_i
      shard_num = params[:shard_num].to_i
      bot_id = params[:bot_id].to_i
      self.current_shard = ShardConnectionData.new(token, shard_id, shard_num, bot_id)
    end

    def authorize_shard
      reject_unauthorized_connection unless current_shard.authorized?
    end
  end
end

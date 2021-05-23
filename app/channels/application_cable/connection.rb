# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_shard

    def connect
      authenticate
      setup_shard_data
    end

    private

    def authenticate
      reject_unauthorized_connection unless JwtRequestAuthorizerService.call(request, controller: 'application_cable')
    end

    def setup_shard_data
      params = request.params
      shard_id = params[:shard_id].to_i
      shard_num = params[:shard_num].to_i
      bot_id = params[:bot_id].to_i
      self.current_shard = ShardConnectionData.new(shard_id, shard_num, bot_id)
    end
  end
end

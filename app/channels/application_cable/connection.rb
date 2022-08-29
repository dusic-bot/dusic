# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_shard

    def connect
      authenticate
      setup_shard_data
      disconnect_outdated
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

    def disconnect_outdated
      outdated_connections = ActionCable.server.connections.select do |c|
        shard = c.current_shard
        shard.identifier == current_shard.identifier && shard.created_at < current_shard.created_at
      end
      return if outdated_connections.empty?

      Rails.logger.info "Closing #{outdated_connections.size} outdated connections"
      outdated_connections.each(&:close)
    end
  end
end

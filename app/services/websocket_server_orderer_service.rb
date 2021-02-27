# frozen_string_literal: true

class WebsocketServerOrdererService
  KNOWN_COMMANDS = %w[reload update_data disconnect restart stop].freeze

  class << self
    def call(command, shards)
      command = command.to_s
      shards = Array(shards).map(&:to_s)

      return if KNOWN_COMMANDS.exclude?(command) || shards.empty?

      shards.each { |s| execute_command(command, s) }
    end

    private

    def execute_command(command, shard_identifier)
      connection = find_connection(shard_identifier)
      shard = connection&.current_shard
      return if shard.blank?

      send(command.to_sym, connection, shard)
    end

    def find_connection(shard_identifier)
      ActionCable.server.connections.find { |s| s.current_shard.identifier == shard_identifier }
    end

    # NOTE: do nothing
    def reload(connection, shard); end

    def update_data(_connection, shard)
      ShardActionBroadcasterService.call(shard, 'update_data')
    end

    def disconnect(connection, _shard)
      connection.close
    end

    def restart(_connection, shard)
      ShardActionBroadcasterService.call(shard, 'restart')
    end

    def stop(_connection, shard)
      ShardActionBroadcasterService.call(shard, 'stop')
    end
  end
end

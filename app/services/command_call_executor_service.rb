# frozen_string_literal: true

class CommandCallExecutorService
  class << self
    def call(shard_identifier, payload)
      shard = find_shard(shard_identifier)
      return if shard.nil?

      ShardActionBroadcasterService.call(shard, 'command_call', JSON.parse(payload))
    end

    private

    def find_shard(identifier)
      ActionCable.server.connections.find { |s| s.current_shard.identifier == identifier }&.current_shard
    end
  end
end

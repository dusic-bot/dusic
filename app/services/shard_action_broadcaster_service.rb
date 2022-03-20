# frozen_string_literal: true

class ShardActionBroadcasterService
  def self.call(shard, action)
    ActionCable.server.broadcast(
      "shards/#{shard.identifier}",
      action:
    )
  end
end

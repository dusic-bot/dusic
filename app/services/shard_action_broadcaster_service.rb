# frozen_string_literal: true

class ShardActionBroadcasterService
  def self.call(shard, action, payload = nil)
    ActionCable.server.broadcast "shards/#{shard.identifier}", { action:, payload: }
  end
end

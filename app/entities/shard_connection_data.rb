# frozen_string_literal: true

class ShardConnectionData
  attr_accessor :servers_count, :cached_servers_count, :active_servers_count

  attr_reader :shard_id, :shard_num, :bot_id, :created_at

  def initialize(shard_id, shard_num, bot_id)
    @shard_id = shard_id
    @shard_num = shard_num
    @bot_id = bot_id
    @created_at = Time.current
  end

  def ==(other)
    shard_id == other.shard_id && shard_num == other.shard_num && bot_id == other.bot_id
  end

  def identifier
    "#{shard_id}_#{shard_num}_#{bot_id}"
  end
end

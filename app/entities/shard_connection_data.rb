# frozen_string_literal: true

class ShardConnectionData
  attr_accessor :servers_count, :cached_servers_count, :active_servers_count

  attr_reader :token, :shard_id, :shard_num, :bot_id

  def initialize(token, shard_id, shard_num, bot_id)
    @token = token
    @shard_id = shard_id
    @shard_num = shard_num
    @bot_id = bot_id
  end

  def authorized?
    return @authorized if defined?(@authorized)

    @authorized =
      JwtAuthorizerService.call(token, access_level: 1) &&
      shard_id >= 0 && shard_id <= shard_num && shard_num >= 1
  end

  def ==(other)
    token == other.token && shard_id == other.shard_id && shard_num == other.shard_num && bot_id == other.bot_id
  end

  def identifier
    "#{shard_id}_#{shard_num}_#{bot_id}"
  end
end

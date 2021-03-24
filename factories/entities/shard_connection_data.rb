# frozen_string_literal: true

FactoryBot.define do
  factory :shard_connection_data do
    shard_id { 0 }
    shard_num { 1 }
    bot_id { 42 }

    initialize_with { new(shard_id, shard_num, bot_id) }
  end
end

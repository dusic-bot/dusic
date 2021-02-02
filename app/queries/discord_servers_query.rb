# frozen_string_literal: true

class DiscordServersQuery
  def self.call(ids)
    DiscordServer.where(id: ids).joins(:setting, :statistic)
  end
end

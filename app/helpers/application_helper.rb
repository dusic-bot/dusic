# frozen_string_literal: true

module ApplicationHelper
  VK_GROUP_URL = 'https://vk.com/dusic_bot'
  DISCORD_SERVER_URL = 'https://discord.gg/4sUeCmQ'
  BOT_INVITE_URL = 'https://discord.com/oauth2/authorize?client_id=479945608824619009&scope=bot&permissions=3213312'
  SOURCE_CODE_URL = 'https://github.com/dusic-bot'

  def title_tag(title, env_prefix: true)
    return tag.title(title) unless env_prefix

    prefix =
      case Rails.env
      when 'development' then 'DEV'
      else ''
      end
    return tag.title(title) if prefix.blank?

    tag.title("#{prefix} | #{title}")
  end
end

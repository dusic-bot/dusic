# frozen_string_literal: true

module Admin::PagesHelper
  def render_audio_item(item)
    case item
    when Playlist then render_playlist(item)
    when Audio then render_audio(item)
    end
  end

  private

  def render_playlist(item)
    title = tag.i { "#{item.title} (#{pluralize(item.size, 'audio')})" }
    audios = tag.ul { render_playlist_audios(item.audios) }

    tag.li { safe_join([title, audios]) }
  end

  def render_playlist_audios(audios)
    safe_join(audios.map { |a| render_audio(a) })
  end

  def render_audio(item)
    tag.li { "#{item.artist} - #{item.title} [#{item.duration_str}]" }
  end
end

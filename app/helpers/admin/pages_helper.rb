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
    <<~HTML
      <i>#{item.title} (#{pluralize(item.size, 'audio')})</i>
      <ul>#{render_playlist_audios(item)}</ul>
    HTML
  end

  def render_playlist_audios(audios)
    audios.map { |a| "<li>#{render_audio(a)}</li>" }.join
  end

  def render_audio(item)
    "#{item.artist} - #{item.title} [#{item.duration_str}]"
  end
end

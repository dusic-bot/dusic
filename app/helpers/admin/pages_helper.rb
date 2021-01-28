# frozen_string_literal: true

module Admin::PagesHelper
  def render_audio_item(item, **li_html_params)
    case item
    when Playlist then render_playlist(item, **li_html_params)
    when Audio then render_audio(item, **li_html_params)
    end
  end

  private

  def render_playlist(item, **li_html_params)
    audios_list_id = "#{manager(item)}_#{item.id}"

    title = render_playlist_title(item, audios_list_id)

    audios_list_params = { class: 'list-group list-group-flush collapse', id: audios_list_id }
    audios_list = tag.ul(**audios_list_params) { render_playlist_audios(item.audios) }

    tag.li(**li_html_params) { tag.div(class: 'card') { safe_join([title, audios_list]) } }
  end

  def render_playlist_title(item, audios_list_id)
    tag.div(class: 'card-header') do
      params = { class: 'btn btn-link', data: { toggle: 'collapse', target: "##{audios_list_id}" } }
      tag.a(**params) do
        "#{item.title} (#{pluralize(item.size, 'audio')})"
      end
    end
  end

  def render_playlist_audios(audios)
    safe_join(audios.map { |a| render_audio(a, class: 'list-group-item pl-5') })
  end

  def render_audio(item, **li_html_params)
    info = tag.span { "#{item.artist} - #{item.title} [#{item.duration_str}]" }
    download_button = render_audio_download_button(item)

    tag.li(**li_html_params) { safe_join([info, download_button]) }
  end

  def render_audio_download_button(item)
    html_params = { class: 'btn btn-light btn-sm float-right', data: { manager: manager(item), id: item.id } }

    tag.div(**html_params) { fa_icon 'download' }
  end

  def manager(item)
    case item
    when Vk::Audio, Vk::Playlist then 'vk'
    else 'unknown'
    end
  end
end

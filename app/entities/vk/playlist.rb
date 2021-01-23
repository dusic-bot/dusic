# frozen_string_literal: true

class Vk::Playlist < Playlist
  def title
    @title ||=
      if external.subtitle.blank?
        external.title
      else
        "#{external.title} - #{external.subtitle}"
      end
  end
end

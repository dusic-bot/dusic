# frozen_string_literal: true

class DiscordServerUpdaterService
  class << self
    def call(server, params)
      setting = params[:setting]
      update_setting(server, setting) if setting.present?

      statistic = params[:statistic]
      update_statistic(server, statistic) if statistic.present?

      today_statistic = params[:today_statistic]
      update_today_statistic(server, today_statistic) if today_statistic.present?
    end

    private

    def update_setting(server, params)
      permitted_params = params.permit(:dj_role, :language, :autopause, :volume, :prefix)
      server.setting.update!(permitted_params)
    end

    def update_statistic(server, params)
      permitted_params = params.permit(:tracks_length, :tracks_amount)
      server.statistic.update!(permitted_params)
    end

    def update_today_statistic(server, params)
      date = params[:date]
      statistic = server.daily_statistics.find_or_create_by!(date: date)
      return unless statistic&.valid?

      permitted_params = params.permit(:tracks_length, :tracks_amount)
      statistic.update!(permitted_params)
    end
  end
end

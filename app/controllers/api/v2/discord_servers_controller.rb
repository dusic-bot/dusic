# frozen_string_literal: true

class Api::V2::DiscordServersController < Api::V2Controller
  before_action :set_server, only: %i[show update]

  def index
    # TODO
  end

  def show
    render json: DiscordServerBlueprint.render(@server)
  end

  def update
    DiscordServerUpdaterService.call(@server, params) unless @server.dm?

    render json: DiscordServerBlueprint.render(@server)
  end

  private

  def set_server
    id = params[:id].to_i
    return head :not_found if id.zero? && params[:id] != '0'

    @server = DiscordServer.find_or_create_by!(external_id: id)
  end
end

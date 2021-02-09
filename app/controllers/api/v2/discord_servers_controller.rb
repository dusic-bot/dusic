# frozen_string_literal: true

class Api::V2::DiscordServersController < Api::V2Controller
  before_action :set_server, only: %i[show update]

  def index
    shard_id = params[:shard_id].to_i
    shard_num = params[:shard_num].to_i

    shard_id = 0 if shard_id < 0
    shard_num = 1 if shard_num <= 0

    servers = DiscordServer.of_shard(shard_id, shard_num)

    render json: DiscordServerBlueprint.render(servers)
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

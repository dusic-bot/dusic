# frozen_string_literal: true

class Api::V2::DiscordServersController < Api::V2Controller
  def index
    # TODO
  end

  def show
    @server = DiscordServer.find_by(external_id: params[:id])

    return head :not_found if @server.nil?

    render json: DiscordServerBlueprint.render(@server)
  end

  def update
    # TODO
  end
end

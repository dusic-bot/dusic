# frozen_string_literal: true

class Api::V2::DiscordServersController < Api::V2Controller
  def index
    # TODO
  end

  def show
    server = DiscordServer.find_or_create_by!(external_id: params[:id])

    render json: DiscordServerBlueprint.render(server)
  rescue ActiveRecord::RecordInvalid
    head :not_found
  end

  def update
    # TODO
  end
end

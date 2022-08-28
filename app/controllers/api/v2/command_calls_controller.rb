# frozen_string_literal: true

class Api::V2::CommandCallsController < Api::V2Controller
  PAYLOAD_KEYS = %i[name arguments options server_id channel_id author_id author_roles_ids].freeze

  before_action :find_connection, only: %i[create]

  def create
    CommandCallExecutorService.call(@connection.current_shard.identifier, permitted_params.slice(*PAYLOAD_KEYS))
    head :created
  end

  private

  def authentication_options
    { controller: '/api/v2/command_calls/' }
  end

  def find_connection
    application_id = Integer(permitted_params[:application_id])
    server_id = Integer(permitted_params[:server_id])

    @connection = ActionCable.server.connections.find do |c|
      next if c.current_shard.bot_id != application_id

      matching_shard?(server_id, c.current_shard)
    end

    head :bad_request if @connection.nil?
  end

  def matching_shard?(server_id, shard)
    (server_id >> 22) % shard.shard_num == shard.shard_id
  end

  def permitted_params
    params.permit(
      :application_id, :server_id, :channel_id, :author_id, :name,
      arguments: [], options: {}, author_roles_ids: []
    )
  end
end

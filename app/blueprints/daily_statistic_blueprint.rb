# frozen_string_literal: true

class DailyStatisticBlueprint < Blueprinter::Base
  EMPTY = {
    'tracks_length' => 0,
    'tracks_amount' => 0,
    'date' => Time.zone.today
  }.freeze

  field :tracks_length
  field :tracks_amount
  field :date
end

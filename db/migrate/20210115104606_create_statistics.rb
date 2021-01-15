class CreateStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :statistics do |t|
      t.belongs_to :discord_server, null: false, index: { unique: true }
      t.integer :tracks_length, default: 0, null: false
      t.integer :tracks_amount, default: 0, null: false

      t.timestamps
    end
  end
end

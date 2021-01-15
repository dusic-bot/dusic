class CreateDailyStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_statistics do |t|
      t.belongs_to :discord_server, null: false, index: false
      t.integer :tracks_length, default: 0, null: false
      t.integer :tracks_amount, default: 0, null: false
      t.date :date, null: false

      t.timestamps
    end

    add_index :daily_statistics, %i[discord_server_id date], unique: true
  end
end

class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.integer :size, default: 0, null: false
      t.datetime :date, null: false
      t.bigint :discord_server_external_id
      t.bigint :discord_user_external_id

      t.timestamps
    end
  end
end

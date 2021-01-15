class CreateDiscordUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_users do |t|
      t.bigint :external_id, null: false

      t.timestamps
    end

    add_index :discord_users, :external_id, unique: true
  end
end

class CreateDiscordServers < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_servers do |t|
      t.bigint :external_id, null: false

      t.timestamps
    end

    add_index :discord_servers, :external_id, unique: true
  end
end

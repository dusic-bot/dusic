class CreateDiscordServers < ActiveRecord::Migration[6.1]
  def change
    create_table :discord_servers do |t|
      t.bigint :external_id, null: false

      t.timestamps
    end
  end
end

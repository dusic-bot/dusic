class ChangeDonationAssociating < ActiveRecord::Migration[6.1]
  def up
    change_table :donations do |t| # rubocop:disable Rails/BulkChangeTable
      t.belongs_to :discord_server, null: true
      t.belongs_to :discord_user, null: true

      t.remove :discord_server_external_id, :discord_user_external_id
    end
  end

  def down
    change_table :donations, bulk: true do |t|
      t.bigint :discord_server_external_id
      t.bigint :discord_user_external_id

      t.remove_references :discord_server, :discord_user
    end
  end
end

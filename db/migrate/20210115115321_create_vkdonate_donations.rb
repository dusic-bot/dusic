class CreateVkdonateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :vkdonate_donations do |t|
      t.belongs_to :donation, null: false, index: { unique: true }
      t.text :message
      t.bigint :vk_user_external_id, null: false
      t.bigint :external_id, null: false

      t.timestamps
    end

    add_index :vkdonate_donations, :external_id, unique: true
  end
end

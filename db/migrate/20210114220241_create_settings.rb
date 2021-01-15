class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.belongs_to :discord_server, null: false, index: { unique: true }
      t.bigint :dj_role
      t.string :language, limit: 2, default: 'ru', null: false
      t.boolean :autopause, default: true, null: false
      t.integer :volume, default: 100, null: false
      t.string :prefix

      t.timestamps
    end
  end
end

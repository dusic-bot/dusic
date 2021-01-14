class AddAdminFlagToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
  end
end

class MigrateFromUser < ActiveRecord::Migration
  def change
    rename_column :addresses, :user_id, :customer_id
    add_index :customers, :email
    add_index :customers, :reset_password_token, :unique => true
  end
end

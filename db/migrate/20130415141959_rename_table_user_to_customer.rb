class RenameTableUserToCustomer < ActiveRecord::Migration
  def change
    remove_index :users, :email
    remove_index :users, :reset_password_token
    rename_table :users, :customers
  end
end

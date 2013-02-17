class RemoveAddressAndEmailFromOrder < ActiveRecord::Migration
  def change
    remove_column :orders, :address
    remove_column :orders, :email
  end
end

class RemoveGuestFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :guest
  end
end

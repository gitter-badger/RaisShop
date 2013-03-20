class RemoveCurrentAddressIdFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :current_address_id
  end

  def down
    add_column :users, :current_address_id, :string
  end
end

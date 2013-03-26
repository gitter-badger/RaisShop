class RemoveFullNameFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :full_name
  end
end

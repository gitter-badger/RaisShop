class ChangeUserIdToAddressIdOnReview < ActiveRecord::Migration
  def change
    add_column :reviews, :address_id, :integer
    add_index :reviews, :address_id
  end
end

class RemoveAddressIdFromReview < ActiveRecord::Migration
  def up
    remove_column :reviews, :address_id
  end

  def down
    add_column :reviews, :address_id, :string
  end
end

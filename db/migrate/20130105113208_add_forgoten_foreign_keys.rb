class AddForgotenForeignKeys < ActiveRecord::Migration
  def up
    add_index :reviews, :product_id
    add_column :reviews, :user_id, :integer
    add_index :reviews, :user_id
  end

  def down
  end
end

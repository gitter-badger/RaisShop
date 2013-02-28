class AddForgotenForeignKeys < ActiveRecord::Migration
  def up
    add_index :reviews, :product_id
  end

  def down
  end
end

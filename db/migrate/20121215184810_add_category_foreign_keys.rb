class AddCategoryForeignKeys < ActiveRecord::Migration
  def up
    add_column :products, :category_id, :integer
    add_index :products, :category_id
  end

  def down
  end
end

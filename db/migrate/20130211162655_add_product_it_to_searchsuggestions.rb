class AddProductItToSearchsuggestions < ActiveRecord::Migration
  def change
    add_column :search_suggestions, :product_id, :integer
    add_index :search_suggestions, :product_id
  end
end

class RemoveSlugFromProducts < ActiveRecord::Migration
  def change
    remove_index :products, :slug
    remove_column :products, :slug
  end
end

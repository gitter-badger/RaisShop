class AddShippingTypeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :shipping_type, :string
  end
end

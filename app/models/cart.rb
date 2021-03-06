class Cart < ActiveRecord::Base

  has_many :line_items, dependent: :destroy

  def empty?
    line_items.empty?
  end


  def add_product(product_id)
    current_item = line_items.find_by_product_id(product_id)
    if current_item
      current_item.increment!(:quantity)
    else
      current_item = line_items.create(product_id: product_id)
    end
    current_item
  end

  def total_price
    line_items.includes(:product).to_a.sum { |item| item.total_price }
  end

  def count
    line_items.sum(:quantity)
  end
end

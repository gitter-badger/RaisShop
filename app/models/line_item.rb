class LineItem
  include Mongoid::Document

  field :quantity, type: Integer, default: 1
  belongs_to :order, inverse_of: :line_items
  belongs_to :product
  belongs_to :cart

  validates_presence_of :product

  validates_numericality_of :quantity, greater_than: 0

  def total_price
    product.price * quantity
  end
end

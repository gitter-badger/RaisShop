class Order
  include Mongoid::Document
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]
  SHIPPING_TYPES = ["Local pick up", "First class", "Express"]

  field :pay_type, type: String
  field :shipping_type, type: String
  field :status, type: String
  field :comment, type: String

  belongs_to :address
  has_many :line_items, dependent: :destroy

  accepts_nested_attributes_for :address

  validates :address, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :shipping_type, inclusion: SHIPPING_TYPES

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end
end

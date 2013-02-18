class Order < ActiveRecord::Base
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]
  SHIPPING_TYPES = ["Check", "Credit card", "Purchase order"]
  attr_accessible :pay_type, :shipping_type

  belongs_to :address

  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :shipping_type, inclusion: SHIPPING_TYPES
end

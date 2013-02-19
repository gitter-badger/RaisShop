class Order < ActiveRecord::Base
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]
  SHIPPING_TYPES = ["Check", "Credit card", "Purchase order"]
  attr_accessible :pay_type, :shipping_type, :address

  belongs_to :address
  has_many :line_items, dependent: :destroy

  validates :address, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :shipping_type, inclusion: SHIPPING_TYPES
end

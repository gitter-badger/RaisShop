class Order < ActiveRecord::Base
  PAYMENT_TYPES = ["Check", "Credit card", "Purchase order"]
  SHIPPING_TYPES = ["Check", "Credit card", "Purchase order"]
  attr_accessible :pay_type, :shipping_type, :address_id, :address_attributes

  belongs_to :address
  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :address

  validates :address, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  validates :shipping_type, inclusion: SHIPPING_TYPES
end

class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id, :user_id
  belongs_to :user
  belongs_to :product

  validates_presence_of :comment, :rating, :product_id, :user_id
end

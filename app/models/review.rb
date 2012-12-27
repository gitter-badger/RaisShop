class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :stars
  belongs_to :user
  belongs_to :product
end

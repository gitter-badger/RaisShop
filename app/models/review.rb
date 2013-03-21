class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id

  belongs_to :user
  belongs_to :product, inverse_of: :reviews

  validates_presence_of :comment, :rating, :product_id, :user

  after_save :average_rating_for_product

  def user_name
    user.full_name
  end

private

  def average_rating_for_product
    product.average_rating
  end
end

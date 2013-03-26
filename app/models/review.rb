class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id

  belongs_to :user
  belongs_to :product, inverse_of: :reviews

  validates_presence_of :comment, :rating, :product_id, :user

  validates_inclusion_of :rating, in: 1..5,
                         message: "Rating should be between 1 and 5"

  before_save :is_uniq_for_product?

  after_save :average_rating_for_product
  after_destroy :average_rating_for_product

  def user_name
    user.full_name
  end

private

  def is_uniq_for_product?
    if new_record? && product.reviews.where(user_id: user.id).count > 0
      errors[:base] << "You already wrote a review for that product"
    end
  end

  def average_rating_for_product
    product.average_rating
  end
end

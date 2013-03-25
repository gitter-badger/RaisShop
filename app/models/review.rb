class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id

  belongs_to :user
  belongs_to :product, inverse_of: :reviews

  validates_presence_of :comment, :rating, :product_id, :user
  validates_numericality_of :rating, greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 5
  before_validation :is_uniq_for_product?

  after_save :average_rating_for_product
  after_destroy :average_rating_for_product

  def user_name
    user.full_name
  end

private

  def is_uniq_for_product?
    if user.nil? || product.nil? ||
        product.reviews.where(user_id: user.id).count == 0
      true
    else
      errors[:base] << "You already wrote a review for that product"
      false
    end
  end

  def average_rating_for_product
    product.average_rating
  end
end

class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id

  belongs_to :user
  belongs_to :product, inverse_of: :reviews

  validates_presence_of :comment, :product_id, :user

  validates_inclusion_of :rating, in: 1..5,
                         message: "Rating should be between 1 and 5"

  validate :is_uniq_for_product?

  after_save :average_rating_for_product
  after_destroy :average_rating_for_product

  def user_name
    user.full_name
  end

private

  def is_uniq_for_product?
    if !user.nil? && !product.nil? &&
        new_record? && !user.can_write_review?(product)
      errors[:base] << "You already wrote a review for that product"
    end
  end

  def average_rating_for_product
    product.average_rating
  end
end

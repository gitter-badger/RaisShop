class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id, :user_id

  belongs_to :user
  belongs_to :product, touch: true#, autosave: true

  validates_presence_of :comment, :rating, :product_id, :user_id

  after_save :average_rating_for_product

  def user_name
    user.full_name
  end

private

  def average_rating_for_product
    self.product.save!
  end
end

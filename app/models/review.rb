class Review < ActiveRecord::Base
  attr_accessible :comment, :helpful, :rating, :product_id, :address_id

  belongs_to :address
  belongs_to :product, touch: true#, autosave: true

  validates_presence_of :comment, :rating, :product_id, :address_id

  after_save :average_rating_for_product

private

  def average_rating_for_product
    self.product.save!
  end
end

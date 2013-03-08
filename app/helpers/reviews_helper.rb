module ReviewsHelper
  def stars_image(rating)
    stars = (5 - (rating || 0) ) * -13 - 1
    "background-position: #{stars}px 0;"
  end

  def can_write_review?
    user_signed_in? &&
      @product.reviews.find_by_address_id(current_user.current_address_id) == nil
  end
end

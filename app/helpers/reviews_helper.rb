module ReviewsHelper
  def stars_image(rating)
    stars = (5 - rating ) * -13 - 1
    "background-position: #{stars}px 0;"
  end

  def average_rating(reviews)
    if reviews.count == 0
      stars_image(0)
    else
      stars_image(reviews.average(:rating).round)
    end
  end

  def can_write_review?
    user_signed_in? &&
      @product.reviews.find_by_user_id(current_user.id) == nil
  end
end

module ReviewsHelper
  def stars_image(rating)
    stars = (5 - (rating || 0) ) * -13 - 1
    "background-position: #{stars}px 0;"
  end

  def show_review_form?
    user_signed_in? && current_user.can_write_review?(@product)
  end
end

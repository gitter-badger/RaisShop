class ReviewDecorator < ApplicationDecorator
  delegate_all

  def destroy_review_link
    if current_user == model.user || current_user.try(:admin?)
      h.link_to 'Destroy review', product_review_path(model.product_id, model),
        method: :delete, data: { confirm: 'Are you sure?' }
    end
  end
end

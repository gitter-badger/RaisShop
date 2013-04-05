class ProductDecorator < ApplicationDecorator
  delegate_all
  decorates_association :reviews

  def link_to_product
    link_to model.title, model
  end

  def add_to_cart_button
    button_to 'Add to cart', line_items_path(product_id: model.id),
      remote: true, class: 'btn'
  end

  def image
    image_tag model.image_url
  end

  def price
    number_to_currency(model.price)
  end

  def review_form
    if user_signed_in? && current_user.can_write_review?(model)
      render 'reviews/form'
    end
  end

  def admin_links
    if current_user.try(:admin?)
      link_to('Edit', edit_product_path(model)) + " " +
      link_to('Destroy', model, method: :delete, data: {confirm: 'Are you sure?'})
    end
  end
end

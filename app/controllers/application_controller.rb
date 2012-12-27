class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  # If the user is not authorized
  def check_authorization
    unless current_user.try(:admin?)
      render file: 'public/403.html', status: 403, layout: false
    end
  end

  helper_method :current_cart
end

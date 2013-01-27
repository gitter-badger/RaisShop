class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :recent_history

  private

  def recent_history
    session[:recent_history] ||= Array.new
    @recent_history = session[:recent_history]
  end

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

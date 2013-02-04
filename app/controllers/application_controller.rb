class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :recent_history

  private

  def recent_history
    session[:recent_history] ||= Hash.new
    history = session[:recent_history]
    items_with_time = Product.find(history.keys).flat_map{|e| [e, history[e.id]]}
    @recent_history = Hash[*items_with_time].sort_by{ |k,v| v }.reverse
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

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :recent_history, :current_cart
  after_filter  :store_location


  #def after_sign_in_path_for(resource)
    #request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  #end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:previous_url] || root_path
    #request.referrer
  end


private

  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def recent_history
    session[:recent_history] ||= Hash.new
    history = session[:recent_history]
    items_with_time = Product.find(history.keys).flat_map{|e| [e, history[e.id]]}
    @recent_history = Hash[*items_with_time].sort_by{ |k,v| v }.reverse
  end

  def current_cart
    @cart ||= Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  # If the user is not authorized
  def check_authorization
    unless current_user.try(:admin?)
      #render file: 'public/403.html', status: 403, layout: false
      redirect_to root_path
    end
  end
end

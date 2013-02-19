class SessionsController < Devise::SessionsController

  def destroy
    cart_id = session[:cart_id]
    super
    session[:cart_id] = cart_id
  end
end

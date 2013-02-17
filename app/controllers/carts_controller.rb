class CartsController < ApplicationController

  def show
    redirect_to @cart unless params[:id].to_i == @cart.id
    @line_items = @cart.line_items.includes(:product)
  end

  def create
    @cart = Cart.new(params[:cart])

    if @cart.save
      redirect_to @cart, notice: 'Cart was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @cart = Cart.find(params[:id])

    if @cart.update_attributes(params[:cart])
      redirect_to @cart, notice: 'Cart was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to root_url, notice: "Your cart is empty"
  end
end

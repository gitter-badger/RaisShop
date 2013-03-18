class OrdersController < ApplicationController
  before_filter :check_authorization, except: [:index, :new, :create]
  before_filter :signed_in_only, only: [:index]

  def index
    @orders = current_user.orders.includes(:address).all
  end

  def new
    if @cart.empty?
      redirect_to root_url, notice: "Your cart is empty"
    else
      @order = Order.new
      if !user_signed_in?
        @address = @order.build_address
        @user    = @address.build_user
      end
    end
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(params[:order])

    @order.add_line_items_from_cart(@cart)

    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to root_path, notice: 'Your order is accepted and being processed'
    else
      render action: "new"
    end
  end

  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to root_path, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    redirect_to orders_url
  end
end

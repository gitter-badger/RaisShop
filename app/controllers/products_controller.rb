class ProductsController < ApplicationController
  before_filter :check_authorization, except: [:index, :show]
  before_filter :find_product, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    #@products = Product.all
    @products = Product.order(:title).page(params[:page])
    respond_with(@products)
  end

  def show
    session[:recent_history].delete(@product.id)
    session[:recent_history] << @product.id
    respond_with(@product)
  end

  def new
    @product = Product.new
    respond_with(@product)
  end

  def edit
  end

  def create
    @product = Product.new(params[:product])
    flash[:notice] = "Product was successfully created." if @product.save
    respond_with(@product)
  end

  def update
    if @product.update_attributes(params[:product])
      flash[:notice] = "Product was successfully updated." 
    end
    respond_with(@product)
  end

  def destroy
    @product.destroy
    respond_with(@product)
  end

private

  def find_product
    @product ||= Product.find_by_slug!(params[:id])
  end

end

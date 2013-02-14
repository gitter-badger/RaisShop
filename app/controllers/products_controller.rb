class ProductsController < ApplicationController
  before_filter :check_authorization, except: [:index, :show]
  before_filter :find_product, only: [:show, :edit, :update, :destroy]
  respond_to :html
  respond_to :json, only: [:index]

  def index
    #@products = Product.order(:title).where("title like ?", "%#{ params[:term] }%")

    per_page = params[:per_page]
    @endless_pagination = per_page == 'all' ? 'true' : 'false'
    per_page = 10 if per_page == 'all' or per_page.nil?

    @products = Product.title_search(params[:term]).page(params[:page])
      .per_page(per_page.to_i)
    respond_with(@products) do |format|
      format.html
      format.js
      format.json { render json: @products.map(&:title) }
    end
  end


  def show
    session[:recent_history].delete(@product.id)
    session[:recent_history][@product.id] = Time.now
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
    @product ||= Product.find(params[:id])
  end

end

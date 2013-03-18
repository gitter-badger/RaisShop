class ProductsController < ApplicationController
  before_filter :check_authorization, except: [:index, :show]

  def index
    #@products = Product.order(:title).where("title like ?", "%#{ params[:term] }%")

    @products = Product.title_search(params[:term]).page(params[:page])
      .per_page(set_default_per_page(params[:page]))
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @products.map(&:title) }
    end
  end


  def show
    @product = Product.includes(reviews: :user).find(params[:id])
    session[:recent_history][@product.id] = Time.now
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product])
    if @product.save
      redirect_to products_path(@product), notice: "Product was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      redirect_to products_path(@product), notice: "Product was successfully updated."
    else
      render action: "edit"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_path
  end

private

  def set_default_per_page(per_page)
    if per_page == 'all' || per_page.nil?
      10
    else
      per_page.to_i
    end
  end
end

class ProductsController < ApplicationController
  before_filter :check_authorization, except: [:index, :show]

  def index
    paginated_products = Product.title_search(params[:term])
          .paginate(page: params[:page], per_page: params[:per_page])
    @products = ProductsDecorator.decorate(paginated_products)
    respond_to do |format|
      format.html
      format.js
      format.json { render json: @products.map(&:title) }
    end
  end


  def show
    @product = Product.find(params[:id]).decorate
    @reviews = @product.reviews
    @review = Review.new
    session[:recent_history][@product.id] = Time.now
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to product_path(@product), notice: "Product was successfully created."
    else
      render action: "new"
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      redirect_to product_path(@product), notice: "Product was successfully updated."
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
  def product_params
      params.require(:product).permit(:title, :description, :image_url,
                                      :price, :category_id)
  end
end

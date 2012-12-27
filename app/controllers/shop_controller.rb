class ShopController < ApplicationController
  def index
    #@products = Product.paginate(page: params[:page], per_page: 15)
  end
  def admin
    unless current_user.try(:admin?)
      render file: 'public/403.html', status: 403, layout: false
    end
  end
  def search
    @products = Product.where("title like ?", "%#{ params[:term] }%")
      .paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html { render template: "products/_product_list" }
      format.json { render json: @products.to_json }
    end
  end
end

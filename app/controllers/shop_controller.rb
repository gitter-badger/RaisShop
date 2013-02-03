class ShopController < ApplicationController

  def index
    #@products = Product.paginate(page: params[:page], per_page: 15)
  end

  def admin
    unless current_user.try(:admin?)
      render file: 'public/403.html', status: 403, layout: false
    end
  end
end

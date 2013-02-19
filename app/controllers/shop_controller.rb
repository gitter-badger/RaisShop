class ShopController < ApplicationController

  before_filter :check_authorization, only: [:admin]

  def index
    #@products = Product.paginate(page: params[:page], per_page: 15)
  end

  def admin
  end
end

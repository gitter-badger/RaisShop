class ReviewsController < ApplicationController
  before_filter :signed_in_only

  def create
    @review = current_user.reviews.build(review_params)
    @review.product = Product.find(params[:product_id])

    if @review.save
      redirect_to :back, notice: 'Review was successfully created.'
    else
      redirect_to :back
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy if @review.user == current_user || current_user.try(:admin?)
    redirect_to :back
  end

private

  def review_params
    params.require(:review).permit(:comment, :helpful, :rating, :product_id)
  end
end

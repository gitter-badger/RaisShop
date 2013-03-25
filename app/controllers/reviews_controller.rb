class ReviewsController < ApplicationController
  before_filter :signed_in_only

  def create
    params[:review][:product_id] = params[:product_id].to_i
    @review = current_user.reviews.build(params[:review])

    notice = ''
    if @review.save
      notice = 'Review was successfully created.'
    else
      flash[:review_errors] = @review.errors.full_messages
    end
    redirect_to :back, notice: notice
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy if @review.user == current_user || current_user.try(:admin?)
    redirect_to :back
  end
end

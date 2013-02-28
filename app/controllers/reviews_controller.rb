class ReviewsController < ApplicationController

  def create
    @review = current_user.current_address.reviews.build(params[:review])

    notice =  @review.save ? 'Review was successfully created.' : 'Review wasnt created.'
    redirect_to :back, notice: notice
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end
end

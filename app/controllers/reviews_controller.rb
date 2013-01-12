class ReviewsController < ApplicationController

  # POST /reviews
  def create
    @review = current_user.reviews.build(params[:review])

    respond_to do |format|
      if @review.save
        format.html { redirect_to :back, notice: 'Review was successfully created.' }
      else
        format.html { redirect_to :back, notice: 'Review wasnt created.' }
      end
    end
  end

  # DELETE /reviews/1
  def destroy
    @review = Review.find(params[:id])
    @review.destroy
  end
end

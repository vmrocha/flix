class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie

  def index
    @reviews = @movie.reviews
  end

  def new
    @review = @movie.reviews.new
  end

  def create
    @review = @movie.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.reviews.find(params[:id]).destroy!
    redirect_to movie_reviews_url(@movie), status: :see_other, alert: "Review successfully deleted!"
  end

  private

  def review_params
    params.require(:review).permit(:stars, :comment)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end

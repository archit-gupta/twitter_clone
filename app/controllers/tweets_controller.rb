class TweetsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_filter :authenticate_user!
  before_filter :check_user, only: [:destroy]

  def check_user
    if current_user != Tweet.find(params[:id]).user
      flash[:alert] = "You are not authorized to access this page"
      redirect_to root_path
    end
  end
  
  def index
    tweet_ids = current_user.followers.pluck("friend_id") + [current_user.id]
    @tweets = Tweet.order("created_at DESC").find_all_by_user_id(tweet_ids)
    @tweet = Tweet.new
    @following = current_user.followers.count
    @followers = Follower.where(:friend_id => current_user.id).count
  end

  def user_tweets
    @tweets = current_user.tweets
  end

  def create

    @tweet = Tweet.new(params[:tweet])
    @tweet.user_id = current_user.id
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render json: {time_ago_in_words: time_ago_in_words(@tweet.created_at), message: @tweet.message, id: @tweet.id} }
      else
        format.html { render action: "new" }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tweet = Tweet.find(params[:tweet_id])
    @tweet.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end

end

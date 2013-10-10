class TweetsController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_filter :authenticate_user!
  before_filter :check_user, only: [:destroy]

  def check_user
    if current_user != Tweet.find(params[:tweet_id]).user
      flash[:alert] = "You are not authorized to access this page"
      return false
    end
  end
  
  def index
    @user = (current_user.blank? ? false : current_user)
    tweet_ids = @user.followers.pluck("friend_id") + [@user.id]
    @tweets = Tweet.order("created_at DESC").find_all_by_user_id(tweet_ids)
    @tweet = Tweet.new
    @following = @user.followers.count
    @followers = Follower.where(:friend_id => @user.id).count
  end

  def create
    if params[:tweet].present?
      @tweet = Tweet.new(params[:tweet]) 
      @tweet.user_id = current_user.id
    else
      @retweet = Tweet.find(params[:tweet_id])
      message = (current_user.friends.exists?(:id => @retweet.user_id) ? @retweet.message : nil)
      @tweet = Tweet.new(:message => message, :user_id => current_user.id)
    end
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

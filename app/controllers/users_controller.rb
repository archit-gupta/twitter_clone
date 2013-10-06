class UsersController < ApplicationController

  before_filter :which_user?, :only => ["following", "followers"]

  def which_user?
    @user = (current_user.blank? ? User.find(params[:id]) : current_user)
  end

  def index
    @heading =  "Users List"
    @user = current_user if current_user.present?
    @users = (current_user.blank? ? User.all : User.find(:all, :conditions => ["id != ?", current_user.id]))
  end

  def following
    @users = @user.friends
    render "users/index"
  end

  def followers 
    @users = User.includes(:followers).where("followers.friend_id = ? AND user_id != ?", @user.id, @user.id)
    render "users/index"
  end

  def show
    @user = User.find_by_user_name(params[:user_name])
    # @current = (current_user.blank? ? User.find_by_user_name(params[:user_name]) : current_user)
    @tweets = Tweet.order("created_at DESC").find_all_by_user_id(@user.id)
    @following = @user.followers.count
    @followers = Follower.where(:friend_id => @user.id).count 
  end

  def user_tweets
    @user = User.find(params[:id])
    @tweets = @user.tweets.order("created_at DESC")
  end

end

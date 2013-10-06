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
    if current_user.present? && current_user.friends.exists?(:user_name => params[:user_name])
      @tweets = Tweet.order("created_at DESC").where(:user_id => @user.id )
    else
      @tweets = Tweet.order("created_at DESC").where("user_id = ? AND private = ?", @user.id, false)
    end
    @following = @user.followers.count
    @followers = Follower.where(:friend_id => @user.id).count 
  end

  def user_tweets
    @user = User.find(params[:id])
    if current_user.present? && current_user.friends.exists?(:id=> @user.id)
      @tweets = @user.tweets.order("created_at DESC").where(:user_id => @user.id )
    else
      @tweets = @user.tweets.order("created_at DESC").where("user_id = ? AND private = ?", @user.id, false)
    end
  end

end

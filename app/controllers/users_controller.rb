class UsersController < ApplicationController
  def index
    @heading =  "Users List"
    @users = (current_user.blank? ? User.all : User.find(:all, :conditions => ["id != ?", current_user.id]))
  end

  def following
    @heading =  "My Followings"
    @users = current_user.friends
    render "users/index"
  end

  def followers
    @heading =  "My Followers"
    @users = User.includes(:followers).where("followers.friend_id = ? AND user_id != ?", current_user.id, current_user.id)
    render "users/index"
  end

end

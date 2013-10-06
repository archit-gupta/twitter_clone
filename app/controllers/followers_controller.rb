class FollowersController < ApplicationController

  before_filter :authenticate_user!

  def create
    @follower = current_user.followers.build(:friend_id => params[:id])
    if @follower.save
      flash[:notice] = "You started following #{@follower.friend.user_name}"
    else
      flash[:alert] = @follower.errors[:friend_id].first
    end
    redirect_to root_path
  end

  def destroy
    @user = current_user.followers.find_by_friend_id(params[:id])
    if @user.destroy
      flash[:notice] = "You unfollowed #{@user.friend.user_name}"
    else
      flash[:alert] = "Something funky happened"
    end
    redirect_to users_index_path
  end
end

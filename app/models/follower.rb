class Follower < ActiveRecord::Base
  attr_accessible :friend_id, :user_id

  belongs_to :friend, :class_name => "User"
  validates :friend_id, :uniqueness => {:scope=>:user_id, :message => "You already following this user"}
end

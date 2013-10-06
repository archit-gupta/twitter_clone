class Tweet < ActiveRecord::Base
  attr_accessible :message, :user_id

  validates :message, presence: true, length: {maximum: 160}
  belongs_to :user
  
end

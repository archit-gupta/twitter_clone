class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_name, :full_name
  # attr_accessible :title, :body

  has_many :followers, :dependent => :destroy
  has_many :friends, :through => :followers

  has_many :tweets, :dependent => :destroy

end

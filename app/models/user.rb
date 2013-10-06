class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :user_name
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_name, :full_name
  # attr_accessible :title, :body

  validates_format_of :user_name, :with => /^[A-Za-z\d_]+$/, :message => "can only be alphanumeric with no spaces"
  validates_uniqueness_of :user_name

  has_many :followers, :dependent => :destroy
  has_many :friends, :through => :followers

  has_many :tweets, :dependent => :destroy

end

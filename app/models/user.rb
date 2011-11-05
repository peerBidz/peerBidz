class User < ActiveRecord::Base


  has_many :bidding
  has_many :items, :through => :bidding

	has_many :notifications

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :dob, :phone, :street, :city, :zip, :state, :country, :is_seller


end

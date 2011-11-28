class User < ActiveRecord::Base


  has_many :bidding
  has_many :items, :through => :bidding

	has_many :notifications

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :dob, :phone, :street, :city, :zip, :state, :country, :is_seller

  def destroy
    #SELLER - logical delete
    #remove all items belonging to user if he is a seller
      if( self.is_seller? )
        #delete all of the seller's items
        deleteme = Item.find_all_by_seller_id(self.id)
        Item.destroy(deleteme)
    
    #BUYER - logical delete
    #remove all bids belongs to a buyer
      else
        #delete all bidding entries for buyer    
        deleteme = Bidding.find_all_by_user_id(self.id)
        Bidding.destroy(deleteme)
      end    

      #delete the user
      super
  end

end

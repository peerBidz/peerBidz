class Item < ActiveRecord::Base

  belongs_to :category
  has_many :bidding
  has_many :users, :through => :bidding

  #before_save :default_values
  #before_validation :before_val

  #def before_val
  #if self.bidvalue_was.to_f.to_s == 0
  # self.bidvalue = 1
  #end
  #end
  has_attached_file :photo, :styles => { :small => "150x150", :medium => "450x450>", :large => "650x650>" }

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'images/png']

  #validates_numericality_of :bidvalue,
  #validates_numericality_of :starting_price

  def destroy
    #-----Notify any bidders of the item before destroying
    @allBidsForItem = Bidding.find_all_by_item_id(self.id)

    #get all users that had bids on the item to be deleted
    @usersThatBid = Array.new
    @allBidsForItem.each do |bid|
      @usersThatBid.push( bid.user_id )
    end

    #remove duplicates from users array
    @usersThatBid.uniq

    #generate notifications for all users that had bid on that item
    @msg = "The following item that you have bid on has been removed: " + self.title
    @usersThatBid.each do |user|
      Notification.create(:user_id=>user, :item_id=>self.id, :delivered=>false, :message=>@msg, :notification_type => 'D')
    end

    #notify the seller that his item has been deleted
    @msg = "Your item (" + self.title + ") has been deleted by an admin"
    Notification.create(:user_id=>self.seller_id, :item_id=>self.id, :delivered=>false, :message=>@msg, :notification_type => 'D')
    #--------------------------------

    #remove all bidding entries belonging to item
    deleteme = Bidding.find_all_by_item_id(self.id)
    Bidding.destroy(deleteme)

    #remove from watchlist of all user
    watchlist_items = Watchlist.find(:all, :conditions => {:item_id => self.id})
    Watchlist.destroy(watchlist_items)

    #delete the item
    super
  end

end

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
    #remove all bidding entries belonging to item
    deleteme = Bidding.find_all_by_item_id(self.id)
    Bidding.destroy(deleteme)

    #delete the item
    self.delete
  end

end

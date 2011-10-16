class Item < ActiveRecord::Base

  #before_save :default_values
  #before_validation :before_val

validate :bid_value_check

def bid_value_check
  if self.bidvalue && (self.bidvalue <= self.bidvalue_was)
    self.errors.add_to_base("Bid is not successful")
  elsif !self.bidvalue
     self.bidvalue = self.starting_price
  end
end


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


  belongs_to :category
end

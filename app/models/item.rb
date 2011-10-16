class Item < ActiveRecord::Base
  #attr_accessor_with_default :bidvalue, 0
  #attr_accessor_with_default :starting_price, 0




  has_attached_file :photo, :styles => { :small => "150x150", :medium => "450x450>", :large => "650x650>" }

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'images/png']


  #validates_numericality_of :bidvalue,
  validates_numericality_of :starting_price
  validates_numericality_of :bidvalue, :greater_than => :bidvalue_was

  belongs_to :category
end

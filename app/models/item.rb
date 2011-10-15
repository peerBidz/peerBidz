class Item < ActiveRecord::Base

  has_attached_file :photo, :styles => { :small => "150x150>", :medium => "450x450>", :large => "650x650>" }

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'images/png']
end

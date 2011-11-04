class Bidding < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :bid_amount, :bid_time

  belongs_to :item
  belongs_to :user


end

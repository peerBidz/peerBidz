class Bidding < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :bid_amount, :bid_time, :item_id, :user_id, :created_at

  belongs_to :item
  belongs_to :user

  validate :bid_value_check


def bid_value_check
  @current_highest_bid = Bidding.find(:first, :conditions => ["item_id IN (?)", self.item_id] , :order => 'bid_amount DESC').bid_amount
  if self.bid_amount && (self.bid_amount <= @current_highest_bid)
    errors.add(:bid_amount, "Sorry, your bid is not successful. Please bid higher than the current price")

  elsif !self.bid_amount
     self.bid_amount = Items.find(id => :item_id).starting_price
  end
end


end

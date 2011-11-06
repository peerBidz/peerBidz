class Bidding < ActiveRecord::Base

  # Setup accessible (or protected) attributes for your model
  attr_accessible :bid_amount, :bid_time, :item_id, :user_id, :created_at

  belongs_to :user

  validate :bid_value_check
  def bid_value_check
    @highest_bid_row = Bidding.find(:first, :conditions => ["item_id IN (?)", self.item_id] , :order => 'bid_amount DESC')
    if @highest_bid_row
    @current_highest_bid = @highest_bid_row.bid_amount
    else
    @current_highest_bid = Item.find(self.item_id).starting_price
    end
    if self.bid_amount && (self.bid_amount <= @current_highest_bid)
    errors.add(:bid_amount, "Sorry, your bid was not successful. Please bid higher than the current price")

    elsif !self.bid_amount
    self.bid_amount = Item.find(self.item_id).starting_price
    end
  end

end

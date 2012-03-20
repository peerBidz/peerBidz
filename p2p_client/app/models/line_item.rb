class LineItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :item
  belongs_to :bidding

  def full_price
    unit_price * quantity
  end

  def total_num
    quantity
  end
end
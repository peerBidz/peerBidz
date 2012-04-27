class Cart < ActiveRecord::Base
  has_many :line_items
  has_one :order
  belongs_to :user

  def total_price
    # convert to array so it doesn't try to do sum on database directly
    line_items.to_a.sum(&:full_price)
  end

  def total_quantity
    line_items.to_a.sum(&:total_num)
  end
end
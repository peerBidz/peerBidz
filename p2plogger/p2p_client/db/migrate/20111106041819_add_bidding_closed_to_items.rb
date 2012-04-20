class AddBiddingClosedToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :bidding_closed, :boolean
  end

  def self.down
    remove_column :items, :bidding_closed
  end
end

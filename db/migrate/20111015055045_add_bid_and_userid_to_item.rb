class AddBidAndUseridToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :bidvalue, :float
    add_column :items, :biduser, :integer
  end

  def self.down
    remove_column :items, :biduser
    remove_column :items, :bidvalue
  end
end

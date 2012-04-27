class AddItemIdUserIdToBidding < ActiveRecord::Migration
  def self.up
    add_column :biddings, :item_id, :integer
  end

  def self.down
    remove_column :biddings, :item_id
  end
end

class CreateBiddings < ActiveRecord::Migration
  def self.up
    create_table :biddings do |t|
      t.datetime :bid_time
      t.integer :bid_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :biddings
  end
end

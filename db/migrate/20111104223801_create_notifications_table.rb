class CreateNotificationsTable < ActiveRecord::Migration
  def self.up
	create_table :notifications do |t|
	  t.integer :user_id
	  t.string :type
	  t.integer :item_id
	  t.boolean :delivered
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end

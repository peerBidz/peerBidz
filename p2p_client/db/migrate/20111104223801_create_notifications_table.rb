class CreateNotificationsTable < ActiveRecord::Migration
  def self.up
	create_table :notifications do |t|
	  t.string :type
	  t.integer :item_id
	  t.boolean :delivered
          t.string :ipaddress
      t.timestamps
    end
  end

  def self.down
    drop_table :notifications
  end
end

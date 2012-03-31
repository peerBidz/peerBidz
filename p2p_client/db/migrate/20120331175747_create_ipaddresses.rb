class CreateIpaddresses < ActiveRecord::Migration
  def self.up
    create_table :ipaddresses do |t|
      t.string :ipaddress

      t.timestamps
    end
  end

  def self.down
    drop_table :ipaddresses
  end
end

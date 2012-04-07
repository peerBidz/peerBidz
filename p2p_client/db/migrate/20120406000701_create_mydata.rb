class CreateMydata < ActiveRecord::Migration
  def self.up
    create_table :mydata do |t|
      t.string :email
      t.string :ipaddress
      t.boolean :is_seller
      
      t.timestamps
    end
  end

  def self.down
    drop_table :mydata
  end
end

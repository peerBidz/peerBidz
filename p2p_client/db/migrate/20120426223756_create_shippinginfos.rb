class CreateShippinginfos < ActiveRecord::Migration
  def self.up
    create_table :shippinginfos do |t|
      t.integer :itemid
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip

      t.timestamps
    end
  end

  def self.down
    drop_table :shippinginfos
  end
end

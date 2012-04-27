class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :first_name
      t.string :last_name
      t.string :card_type
      t.date :card_expires_on
      t.string :street
      t.string :city
      t.string :zip
      t.string :state
      t.integer :phone
      t.string :country
      t.integer :cart_id

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end

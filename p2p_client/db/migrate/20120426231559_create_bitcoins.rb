class CreateBitcoins < ActiveRecord::Migration
  def self.up
    create_table :bitcoins do |t|
      t.integer :itemid
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :bitcoins
  end
end

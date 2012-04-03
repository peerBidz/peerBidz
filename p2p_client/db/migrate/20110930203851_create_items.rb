class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.string :title
      t.string :description
      t.boolean :condition
      t.decimal :starting_price
      t.integer :duration
      t.string :category
      t.integer :seller_id

      t.timestamps
    end
  end

  def self.down
    drop_table :items
  end
end

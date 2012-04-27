class CreateSellerrings < ActiveRecord::Migration
  def self.up
    create_table :sellerrings do |t|
      t.string :ipaddress
      t.string :iptype
      t.string :category
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :sellerrings
  end
end

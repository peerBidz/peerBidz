class CreateSellerrings < ActiveRecord::Migration
  def self.up
    create_table :sellerrings do |t|
      t.string :ip
      t.string :predecessor
      t.string :successor
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :sellerrings
  end
end

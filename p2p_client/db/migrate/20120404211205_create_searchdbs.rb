class CreateSearchdbs < ActiveRecord::Migration
  def self.up
    create_table :searchdbs do |t|
      t.string :buyeripaddress
      t.string :searchquery
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :searchdbs
  end
end

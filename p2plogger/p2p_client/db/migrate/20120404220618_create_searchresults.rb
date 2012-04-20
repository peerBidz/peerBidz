class CreateSearchresults < ActiveRecord::Migration
  def self.up
    create_table :searchresults do |t|
      t.string :search_string
      t.string :category
      t.string :ipaddress
      t.string :returned_string

      t.timestamps
    end
  end

  def self.down
    drop_table :searchresults
  end
end

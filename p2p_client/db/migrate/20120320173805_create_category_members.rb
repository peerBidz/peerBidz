class CreateCategoryMembers < ActiveRecord::Migration
  def self.up
    create_table :category_members do |t|
      t.integer :id
      t.string :ipAddress
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :category_members
  end
end

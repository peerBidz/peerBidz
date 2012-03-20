class CreateCategoryMembers < ActiveRecord::Migration
  def change
    create_table :category_members do |t|
      t.string :cname
      t.integer :ipAddr

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :uname
      t.string :password
      t.integer :seller
      t.text :keyurl

      t.timestamps
    end
  end
end

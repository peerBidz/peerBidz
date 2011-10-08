class AddUsernameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :dob, :string
    add_column :users, :street, :string
    add_column :users, :city, :string
    add_column :users, :zip, :string
    add_column :users, :state, :string
  end

  def self.down
    remove_column :users, :state
    remove_column :users, :zip
    remove_column :users, :city
    remove_column :users, :street
    remove_column :users, :dob
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end

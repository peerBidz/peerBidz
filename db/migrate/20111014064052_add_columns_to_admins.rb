class AddColumnsToAdmins < ActiveRecord::Migration
  def self.up
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
    add_column :admins, :dob, :string
    add_column :admins, :street, :string
    add_column :admins, :city, :string
    add_column :admins, :zip, :string
    add_column :admins, :state, :string
  end

  def self.down
    remove_column :admins, :state
    remove_column :admins, :zip
    remove_column :admins, :city
    remove_column :admins, :street
    remove_column :admins, :dob
    remove_column :admins, :last_name
    remove_column :admins, :first_name
  end
end

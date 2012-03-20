class AddPhoneCountryDobToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :integer
    add_column :users, :country, :string
    add_column :users, :dob, :date
  end

  def self.down
    remove_column :users, :dob
    remove_column :users, :country
    remove_column :users, :phone
  end
end

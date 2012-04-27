class RemoveDobFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :dob
  end

  def self.down
    add_column :users, :dob, :string
  end
end

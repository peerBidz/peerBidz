class AddIsSellerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_seller, :boolean
  end

  def self.down
    remove_column :users, :is_seller
  end
end

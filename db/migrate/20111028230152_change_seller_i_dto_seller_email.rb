class ChangeSellerIDtoSellerEmail < ActiveRecord::Migration
  def self.up
  	remove_column :searches, :seller_id
  	add_column :searches, :seller_email, :string
  end

  def self.down
  	add_column :searches, :seller_id, :integer
  	remove_column :searches, :seller_email
  end
end

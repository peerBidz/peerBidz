class AddExpiresAtToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :expires_at, :datetime
  end

  def self.down
    remove_column :items, :expires_at
  end
end

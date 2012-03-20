class AddIsPaidToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :is_paid, :boolean
  end

  def self.down
    remove_column :items, :is_paid
  end
end

class AddBuyPriceToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :for_sale, :boolean
    add_column :items, :buy_price, :decimal
  end

  def self.down
    remove_column :items, :for_sale
    remove_column :items, :buy_price
  end
end

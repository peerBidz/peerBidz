#THIS FILE IS NOT EXECUTED!! 
# the code was moved to \config\initializers\task_scheduler.rb

=begin

task :environment do

end

namespace :biddingTasks do

  desc "If Item expires, find who is the winner and add a record in the notification table"

  task :winner_notify => :environment do
  puts "inside the task"
  @items = Item.find(:all, :conditions => ["bidding_closed = ?", false])
    @items.each do |item|
      if DateTime.now.to_formatted_s(:db) >= item.expires_at.to_formatted_s(:db)
        puts("entered to item loop")
        Item.update(item.id, :bidding_closed => true)
        item.save
        @highest_bid_row = Bidding.find(:first, :conditions => ["item_id IN (?)", item.id] , :order => 'bid_amount DESC')
        if @highest_bid_row
          #notify buyer (winner of item)
          Notification.create!(:user_id => @highest_bid_row.user_id, :item_id => item.id , :message => "Congrats! You have won "+ item.title, :delivered => false)
          #notify seller
          Notification.create!(:user_id => item.seller_id, :item_id => item.id , :message => "Congrats! You have sold "+ item.title, :delivered => false)
        end
        else
      end
    end
  end

  desc "Run all tasks in this file"
	task :all => [:winner_notify]

end

=end
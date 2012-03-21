# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require 'rubygems'
require 'rake'
require 'rufus/scheduler'

#load File.join( Rails.root.to_s, 'lib', 'tasks', 'bidding_tasks.rake')

scheduler = Rufus::Scheduler.start_new

scheduler.every("20s") do
  #Rake::Task["biddingTasks:winner_notify"].invoke

    @items = Item.find(:all, :conditions => ["bidding_closed = ?", false])

    @items.each do |item|
      if DateTime.now.to_formatted_s(:db) >= item.expires_at.to_formatted_s(:db)
        #puts("entered to item loop")
        Item.update(item.id, :bidding_closed => true)
        item.save
        @highest_bid_row = Bidding.find(:first, :conditions => ["item_id IN (?)", item.id] , :order => 'bid_amount DESC')
        if @highest_bid_row
        #notify buyer (winner of item)
        Notification.create!(:user_id => @highest_bid_row.user_id, :item_id => item.id , :message => "Congrats! You have won "+item.title, :delivered => false, :notification_type => "W")

        #notify seller
        Notification.create!(:user_id => item.seller_id, :item_id => item.id , :message => "Congrats! You have sold "+ item.title, :delivered => false, :notification_type => "S")
        end
        else
      end
    end
end

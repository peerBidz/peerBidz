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
require 'xmlrpc/client'

#load File.join( Rails.root.to_s, 'lib', 'tasks', 'bidding_tasks.rake')

scheduler = Rufus::Scheduler.start_new
if ActiveRecord::Base.connection.table_exists? 'searchresults'
Searchresults.delete_all
end
if ActiveRecord::Base.connection.table_exists? 'ipaddresses'
Ipaddress.delete_all
end
if ActiveRecord::Base.connection.table_exists? 'mydata'
Mydata.delete_all
end
if ActiveRecord::Base.connection.table_exists? 'notifications'
Notification.delete_all
end
if ActiveRecord::Base.connection.table_exists? 'searchdbs'
Searchdb.delete_all
end

if ActiveRecord::Base.connection.table_exists? 'searchdbs'
@myvar = Sellerring.where("iptype <> 'bootstrap'")
@myvar.each do |entry|
	entry.delete
	end
end
scheduler.every("20s") do

    @items = Item.find(:all, :conditions => ["bidding_closed = ?", false])

    bflag = 1

    @items.each do |item|
	puts DateTime.now.to_s(:number)
	puts "print item expires_at"
	puts item.expires_at.to_s(:number)
      if DateTime.now.to_s(:number) >= item.expires_at.to_s(:number)
        #puts("entered to item loop")
        Item.update(item.id, :bidding_closed => true)
        item.save
        @highest_bid_row = Bidding.find(:all, :conditions => ["item_id IN (?)", item.id] , :order => 'bid_amount DESC')
        puts @highest_bid_row.length

        @highest_bid_row.length.times do |i|

        #notify buyer (winner of item)
        puts @highest_bid_row[i].ipaddress
        @serverPre = XMLRPC::Client.new(@highest_bid_row[i].ipaddress, "/api/xmlrpc", 3000)

          begin
            @my_address = Mydata.first.localaddress
            msg = "Congrats! You have won "+item.title
            @sellervalue = @serverPre.call("Container.sendNotification", @my_address, item.id, msg, "false", "W")

            # Notify
            Notification.create!(:ipaddress =>  @highest_bid_row[i].ipaddress, :item_id => item.id , :message => "Congrats! You have sold "+ item.title, :delivered => false, :notification_type => "S")
            bflag = 0
            break
          rescue
            #Fault tolerance here
            puts "failed to connect to top buyer. Trying the next one"
          end
        end

        # If none of the buyers are online
        if bflag == 1
           Notification.create!(:ipaddress =>  @my_address, :item_id => item.id , :message => "None of your buyers are online for "+ item.title, :delivered => false, :notification_type => "D")
        end

      end
    end
end

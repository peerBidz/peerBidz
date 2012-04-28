require 'xmlrpc/server'
require 'xmlrpc/client'
require 'socket'

class RpcController < ApplicationController


  exposes_xmlrpc_methods

  add_method 'Container.bitcoinInfo' do |itemid, address|
  	@bit = Bitcoin.new
	@bit.itemid = itemid.to_i()
	@bit.address = address
	@bit.save
  end
  add_method 'Container.buyerInfo' do |itemid, name, street, city, state, zip, country|
	@ship = Shippinginfo.new  	
	@ship.itemid = itemid.to_i()
	@ship.name = name
	@ship.street = street
	@ship.city = city
	@ship.state = state
	@ship.zip = zip
	@ship.country = country
	@ship.save
	
	@myNote = Notification.where("item_id = ?", itemid).first
	@myNote.notification_type = 'P'
	@myNote.save
  end
  add_method 'Container.placeBid' do |name, category, amount, ipaddress|
	@myItem = Item.where("title = ? and category =?", name, category)
	@highBid = Bidding.where("item_id = ?", @myItem.first.id).order("bid_amount DESC").first	

	isHighest = 1
	if @myItem.first != nil
		if @myItem.first.starting_price > Integer(amount)
			puts "here"
			isHighest = 0
		end
		if @highBid != nil
			highVal = @highBid.bid_amount	
			puts "amount is"
			puts amount
			if Integer(highVal) >= Integer(amount)
				isHighest = 0
                        else 
                          if ipaddress != @highBid.ipaddress
			  @my_address =  Mydata.first.localaddress 
                          msg = "You have been outbid on: " + @myItem.first.title
                          begin
                            @serverPre = XMLRPC::Client.new(@highBid.ipaddress, "/api/xmlrpc", 3000)
				Thread.new{
                            		@serverPre.call2_async("Container.sendNotification", @my_address, @myItem.first.id, msg, "false", "O")
                         	} 
			 rescue
                            puts "Failed to connect to the out bid buyer"
                          end
			end
			end
		end
	end
	if @myItem.first != nil
		
		if isHighest == 1
			@myBid = Bidding.new
			@myBid.ipaddress = ipaddress
			@myBid.bid_amount = amount
			@myBid.item_id = @myItem.first.id
			@myBid.bid_time = Time.now
			@myBid.save

                        @msg =  "There is a new bid on your item (" + @myItem.first.title + ") for $" + amount + " !"
                        Notification.create(:ipaddress=> @my_address, :item_id=>@myItem.first.id, :message=>@msg, :delivered=>"false", :notification_type => 'N')

     			{ "value" => "success" }
		else
			{ "value" => "Bid amount is lower than the current highest bid. Place a higher bid" }
		end
	else
		{"value" => "Invalid item"}
	end
  end

  add_method 'Container.getBackupParent' do |category|
  	puts "IN GET BACKUP PARENT" 
     @myvar = Sellerring.where("category = ?", category).order("updated_at asc").first 
     
    if @myvar != nil
	puts "not nil"
     @myvar.updated_at = DateTime.now  
     @myvar.save 
 
     { "value" => @myvar.ipaddress }
 	else

   
     { "value" => "0" }
	end
   end
  
# Call this method when informing a neighbor of a dead IP
add_method 'Container.neighborDeath' do |category, deadip, newip|

	@myDead = Sellerring.where("ipaddress = ? and category = ?", deadip, category).all
	lostPred = 0
	lostSucc = 0

	# Delete dead IP from seller ring
	@myDead.each do |entry|
		if entry.iptype == "predecessor"
			lostPred = 1
		end
		if entry.iptype == "successor"
			lostSucc = 1
		end
		entry.delete
	end

	# if lost predecessor, add new predecessor
	if lostPred == 1
		@newPred = Sellerring.new
		@newPred.iptype = "predecessor"
		@newPred.ipaddress = newip
		@newPred.category = category
		@newPred.save
		{"value"=> "0"}
		if lostSucc == 0
			# tell successor to update backups accordingly
			@successor = Sellerring.where("category = ? and iptype = 'successor'", category).first
			if @successor != nil
      			@callsucc = XMLRPC::Client.new(@successor.ipaddress, "/api/xmlrpc", 3000)
      			Thread.new {
				@callsucc.call_async("Container.updateRingBackup", ipaddress)
			}
			{"value" => @successor.ipaddress}
			end
		end
	end
	
	# if lost successor, add new successor
	if lostSucc == 0
		@newPred = Sellerring.new
		@newPred.iptype = "successor"
		@newPred.ipaddress = newip
		@newPred.category = category
		@newPred.save
		if lostPred == 0
			# tell successor to update backups accordingly
			@cpred = Sellerring.where("category = ? and iptype = 'predecessor'", category).first
			if @cpred != nil
      			@callpred = XMLRPC::Client.new(@cpred.ipaddress, "/api/xmlrpc", 3000)
      			Thread.new {
				@callpred.call_async("Container.updateRingBackup", ipaddress)
			}
			{"value" => @cpred.ipaddress}
			end
		end
	end
end


# Call this to update backup predecessor/successor
add_method 'Container.updateRingBackup' do |category, deadip, newip|
	@backups = Sellerring.where('category = ?').all
	if @backups != nil
		@backups.each do |back|
			back.ipaddress = newip			
		end
	end
end

add_method 'Container.parentDeathSwitch' do |category, ipaddress|
  	puts "PARENT DEATH" 
	@boot = Sellerring.where("iptype = 'bootstrap'").first
      	@server1 = XMLRPC::Client.new(@boot.ipaddress, "/api/xmlrpc", 3001)
      	Thread.new {
		@server1.call_async("Container.removeDeadSeller", ipaddress)
	}
     	
	@myvar = Sellerring.where("category = ? and ipaddress <> ?", category, ipaddress).order("updated_at asc").first 
    	puts "after 1st" 
	@myDead = Sellerring.where("category = ? and ipaddress = ? and (iptype='predecessor' or iptype='successor') ", category, ipaddress)
	puts "next"
	if @myDead != nil
		puts "not nil"
		if @myDead.count == 2
			puts "count = 2"
			# No other ring members. delete predecessor/successor
			@myDead.each do |entry|
				entry.delete
			end
			puts "Lost predecessor/successor"
		else
			puts "not 2 count"
			@dead = @myDead.first
			if @dead.iptype == "predecessor"
				# lost a predecessor
				# TODO: RPC to update links
				puts "Lost my predecessor"
				@myBackup = Sellerring.where("category = ? and iptype = 'backup_predecessor'", category).first
				if @myBackup != nil
					# connect to backup successor
					# todo: RPC to update links
					@localInfo = Mydata.first
      					@callbackup = XMLRPC::Client.new(@myBackup.ipaddress, "/api/xmlrpc", 3000)
      					Thread.new {
						@callbackup.call_async("Container.neighborDeath", category, @dead.ipaddress, @localInfo.localaddress)
					}
					
				else
					# no predecessor, connect to successor
					@succInfo = Sellerring.where("category = ? and iptype='successor'", category).first
					if @succInfo != nil
						@localInfo = Mydata.first
      						@callbackup = XMLRPC::Client.new(@succInfo.ipaddress, "/api/xmlrpc", 3000)
      						Thread.new {
							@callbackup.call_async("Container.neighborDeath", category, @dead.ipaddress, @localInfo.localaddress)
						}
						
					end
				end
			else
				# lost a successor
				puts "Lost my successor"
				@myBackup = Sellerring.where("category = ? and iptype = 'backup_successor'", category).first
				if @myBackup != nil
					# connect to backup successor
					# todo: RPC to update links
					puts "connect to backup"
					@localInfo = Mydata.first
      					@callbackup = XMLRPC::Client.new(@myBackup.ipaddress, "/api/xmlrpc", 3000)
      					Thread.new {
						@result = @callbackup.call("Container.neighborDeath", category, @dead.ipaddress, @localInfo.localaddress)
						if @result["value"] != "0"
							@back = Sellerring.where("iptype='backup_successor' and category = ?", category).first
							if @back != nil
								@back.ipaddress = @result["value"]
								@back.save
							else
								@newBack = Sellerring.new
								@newBack.iptype = 'backup_successor'
								@newBack.ipaddress = @result["value"]
								@newBack.save
							end
						end
					}
				else
					# no successor, connect to predecessor
					puts "connect to predecessor"
					@predInfo = Sellerring.where("category = ? and iptype='predecessor'", category).first
					@succInfo = Sellerring.where("category = ? and iptype='successor'", category).first
					if @predInfo != nil
						if @succInfo != nil
							@succInfo.ipaddress = @predInfo.ipaddress
							@succInfo.save
						end
						@localInfo = Mydata.first
      						@callbackup = XMLRPC::Client.new(@predInfo.ipaddress, "/api/xmlrpc", 3000)
      						Thread.new {
							@result = @callbackup.call_async("Container.neighborDeath", category, @dead.ipaddress, @localInfo.localaddress)
						if @result["value"] != "0"
							@back = Sellerring.where("iptype='backup_predecessor' and category = ?", category).first
							if @back != nil
								@back.ipaddress = @result["value"]
								@back.save
							else
								@newBack = Sellerring.new
								@newBack.iptype = 'backup_predecessor'
								@newBack.ipaddress = @result["value"]
								@newBack.save
							end
						end
						}
					else
						if @succInfo != nil
							@succInfo.delete
						end	
					end
				end
			end 
		end
	end
	if @myvar != nil
		puts "not nil"
     		@myvar.updated_at = DateTime.now  
     		@myvar.save 
 	
     		{ "value" => @myvar.ipaddress }
 	else
   		{ "value" => "0" }
	end
   end

  add_method 'Container.getItemInfo' do |category, title|

	@myItem = Item.where("category = ? and title = ?", category, title).first
	@myBids = Bidding.where("item_id = ?", @myItem.id).order("bid_amount desc")
	highBid = "0"
	if @myBids != nil
		if @myBids.count != 0
			highBid = @myBids.first.bid_amount
		end
	end
	puts @myItem.description
	puts @myItem.starting_price
	puts @myItem.expires_at
	puts "highBid"
        { "description" => @myItem.description, "startprice" => @myItem.starting_price.to_s(), "expires" => @myItem.expires_at.to_s(), "highbid" => highBid.to_s() }

  end
  add_method 'Container.extendSellerRing' do |ipaddress, category|

     @myvar = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "predecessor"})

     if @myvar.count != 0
       predecessor = @myvar.first.ipaddress
       @myvar.first.ipaddress = ipaddress
       @myvar.first.save
       puts "Var Count"
       puts predecessor
	   dbvalue = Sellerring.new
	   dbvalue.ipaddress = predecessor
	   dbvalue.iptype = 'backup_predecessor'
	   dbvalue.category = category
	   dbvalue.updated_at = DateTime.now
	   dbvalue.created_at = DateTime.now
	   dbvalue.save

	   
    else
       puts "Not in var count"

       # If there only two sellers in a category case
       dbvalue = Sellerring.new
       dbvalue.ipaddress = ipaddress
       dbvalue.iptype = 'successor'
       dbvalue.category = category
       dbvalue.updated_at = DateTime.now
       dbvalue.created_at = DateTime.now
       dbvalue.save

       dbvalue = Sellerring.new
       dbvalue.ipaddress = ipaddress
       dbvalue.iptype = 'predecessor'
       dbvalue.category = category
       dbvalue.updated_at = DateTime.now
       dbvalue.created_at = DateTime.now
       dbvalue.save

       predecessor = 0
    end

     @mySuccessor = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "successor"})
     backupSuccessor = "0"	
     if @mySuccessor.count != 0
		 if @mySuccessor.first.ipaddress != ipaddress
			backupSuccessor = @mySuccessor.first.ipaddress
			@mysucc = XMLRPC::Client.new(backupSuccessor, "/api/xmlrpc", 3000)
			Thread.new{
				@mysucc.call2_async("Container.updateBackup", ipaddress, @category, "backup_predecessor")
			}
		end
     end

    {"value" => predecessor, "backup_successor" => backupSuccessor}
end


  add_method 'Container.updateSuccessor' do |ipaddress, category|

     @myvar = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "successor"}).first
     @myvar.ipaddress = ipaddress
     @myvar.save
     
     backupPred = "0"
     @myPred = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "predecessor"}).first
     if @myPred != nil
     	backupPred = @myPred.ipaddress
     end
     {"value" => backupPred }
  end

  add_method 'Container.updateBackup' do |ipaddress, category, type|

     @myvar = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => type}).first
     if @myvar != nil
		@myvar.ipaddress = ipaddress
		@myvar.save
	 else 
		dbvalue = Sellerring.new
       dbvalue.ipaddress = ipaddress
       dbvalue.iptype = type
       dbvalue.category = category
       dbvalue.updated_at = DateTime.now
       dbvalue.created_at = DateTime.now
       dbvalue.save	   
	 end

  end
  add_method 'Container.get_sellerorigin' do |search_string, category_name, ip|
    # end old searches
    @oldreq = Searchdb.where("buyeripaddress = ?", ip).all
    if @oldreq != nil
    	@oldreq.each do |old|
		old.delete
    	end
    end

    # start new search
    @request = Searchdb.new 
    @request.buyeripaddress = ip
    @request.searchquery = search_string
    @request.category = category_name
    @request.save

    @search_id = Searchdb.where("category = :ct AND buyeripaddress = :it AND searchquery = :sq ", {:ct => category_name, :it => ip, :sq => search_string}).first
    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{search_string}%", category_name])
    @ip_address = Mydata.first.localaddress 

    @neighbors = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"}) 
 

if @neighbors != nil
if @neighbors.count != 0
	puts "neighbor is not nil"
      @successor = @neighbors.first.ipaddress

      @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3000)
      Thread.new {
	@server1.call_async("Container.get_sellerip", search_string,category_name, @ip_address, @search_id.id)
	}
end
	puts "after async"
end
      
  
      if @items != nil
	if @items.count != 0
	puts "have items to send"
        { "value" => @ip_address, "search" => search_string, "category" => category_name , "returnedstring" => @items.first.title}
	else
      { "value" => "0"}
	end
	else
      { "value" => "0"}
	end


  end

  add_method 'Container.get_sellerip' do |search_string, category_name, ip_address, search_id|

    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{search_string}%", category_name])
	my_address = Mydata.first.localaddress
	
    if ip_address != my_address
      @neighbors = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"})

        @successor = @neighbors.first.ipaddress
          
	Thread.new {
        @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3000)
        @server1.call2_async("Container.get_sellerip", search_string,category_name, ip_address, search_id)
   
	}
      if @items != nil
	if @items.count != 0
          @server1 = XMLRPC::Client.new(ip_address, "/api/xmlrpc", 3000)
	puts "found item"
        Thread.new {  
		@server1.call2_async("Container.get_itemavailability", my_address, search_id, @items.first.title)
	}      
	end
	end 
    end

    { "value" => "0"}
  end

  add_method 'Container.get_itemavailability' do |ip_address, search_id, item_name|

        @is_present = Searchdb.where("id = :ct", {:ct => search_id})

        if @is_present != nil
          if @is_present.count != 0

            @server1 = XMLRPC::Client.new(@is_present.first.buyeripaddress, "/api/xmlrpc", 3000)
	    puts "item"
		puts item_name 
		puts "category"
		puts  @is_present.first.category
		puts "ip"
		
            Thread.new {
                 @server1.call2_async("Container.itemFound", ip_address, item_name, @is_present.first.category, @is_present.first.searchquery)
            }

          end
        end
            { "value" => "0"}

    end

  add_method 'Container.itemFound' do |ip_address, item_name, category, search_query|

        dbvalue = Searchresults.new
 
        dbvalue.search_string = search_query
        dbvalue.category = category
        dbvalue.ipaddress = ip_address

        dbvalue.returned_string = item_name
        dbvalue.save

    end

  add_method 'Container.getIdentity' do |isSeller,email,ipaddress|
   
	@identDB = Mydata.new
	@identDB.email = email
	@identDB.is_seller = isSeller
        @identDB.localaddress = ipaddress
	@identDB.save
  end

  add_method 'Container.sendNotification' do |ipaddress, item_id,msg,state,type|

        @identDB = Notification.new
        @identDB.item_id = item_id
        @identDB.ipaddress = ipaddress
        @identDB.delivered = state
        @identDB.message = msg
        @identDB.notification_type = type
        @identDB.save
  end 
end

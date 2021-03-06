require 'xmlrpc/server'
require 'xmlrpc/client'
require 'socket'

class RpcController < ApplicationController


  exposes_xmlrpc_methods

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
     			{ "value" => "success" }
		else
			{ "value" => "Bid amount is lower than the current highest bid. Place a higher bid" }
		end
	else
		{"value" => "Invalid item"}
	end
  end

  add_method 'Container.getBackupParent' do |category|
   
     @myvar = Sellerring.where("category = ?", category).order("updated_at asc").first 
     
    if @myvar != nil
     @myvar.updated_at = DateTime.now  
     @myvar.save 
 
     { "value" => @myvar.ipaddress }
     end
   
     { "value" => "0" }
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
       backupSuccessor = @mySuccessor.first.ipaddress
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

  add_method 'Container.get_sellerorigin' do |search_string, category_name, ip|

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
end

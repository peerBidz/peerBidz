require 'xmlrpc/server'
require 'xmlrpc/client'
require 'socket'

class RpcController < ApplicationController


  exposes_xmlrpc_methods

  add_method 'Container.method_name' do |category|
   
     @myvar = Sellerring.where("category = ?", category).order("updated_at asc").first 
     @myvar.updated_at = DateTime.now  
     @myvar.save 
 
    { "value" => @myvar.ipaddress }
  end

  add_method 'Container.sellermethod' do |ipaddress, category|

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
    
    {"value" => predecessor}
end
  add_method 'Container.updateSuccessor' do |ipaddress, category|

     @myvar = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "successor"}).first
     @myvar.ipaddress = ipaddress
     @myvar.save
	
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
	puts "neighbor is not nil"
      @successor = @neighbors.first.ipaddress

      @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3000)
      Thread.new {
	@server1.call_async("Container.get_sellerip", search_string,category_name, @ip_address, @search_id.id)
	}
	puts "after async"
end
      
  
      if @items != nil
        { "value" => @ip_address, "search" => search_string, "category" => category_name }
      end

      { "value" => "0"}

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
          @server1 = XMLRPC::Client.new(ip_address, "/api/xmlrpc", 3000)
        Thread.new {  
		@server1.call2_async("Container.get_itemavailability", my_address, search_id)
	}      
	end 
    end

    { "value" => "0"}
  end

  add_method 'Container.get_itemavailability' do |ip_address, search_id|

        @is_present = Searchdb.find(search_id)

        if @is_present != nil
          @server1 = XMLRPC::Client.new(@is_present.buyeripaddress, "/items?results", 3000)
          @server1.call("index")
          { "value" => nil}
        end
    end
  add_method 'Container.getIdentity' do |isSeller,email,ipaddress|
   
	@identDB = Mydata.new
	@identDB.email = email
	@identDB.is_seller = isSeller
        @identDB.localaddress = ipaddress
	@identDB.save
  end 
end

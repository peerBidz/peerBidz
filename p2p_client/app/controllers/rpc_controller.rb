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
       @myvar.first.destroy
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

       predecessor = 0
    end
end
  add_method 'Container.updateSucessor' do |ipaddress, category|

     @myvar = Sellerring.where("category = :ct AND iptype = :pt", {:ct => category, :pt => "successor"}).first
     @myvar.ipaddress = ipaddress
     @myvar.save
	
  end

  add_method 'Container.get_sellerorigin' do |search_string, category_name, ip_address|

    @request = Searchdb.new 
    @request.buyeripaddress = ip_address
    @request.searchquery = search_string
    @request.category = category_name
    @request.save

    @search_id = Searchdb.where("category = :ct AND buyeripaddress = :it AND searchquery = :sq ", {:ct => category_name, :it => ip_address, :sq => search_string})
    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{search_string}%", category_name])
    @ip_address = UDPSocket.open {|s| s.connect('65.59.196.211', 1); s.addr.last } 

    @neighbours = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"}) 
 
    @neighbours.length.times do |i|
      @sucessor = @neighbours[i].ipaddress

      @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3000)
      @server1.call2_async("Container.get_sellerip", search_string,category_name, @ip_address, @search.id)
      { "value" => nil}
    end
        
      if @items != nil
        { "value" => @ip_address, "search" => search_string, "category" => category_name }
      end
  end

  add_method 'Container.get_sellerip' do |search_string, category_name, ip_address, search_id|

    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{search_string}%", category_name])
    my_address = UDPSocket.open {|s| s.connect('65.59.196.211', 1); s.addr.last } 


    if ip_address != my_address
      @neighbours = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"})

      @neighbours.length.times do |i|
        @sucessor = @neighbours[i].ipaddress
          
        @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3000)
        @server1.call2_async("Container.get_sellerip", search_string,category_name, ip_address)
      end

      if @items == nil
          @server1 = XMLRPC::Client.new(ip_address, "/api/xmlrpc", 3000)
          @server1.call2_async("Container.get_itemavailability", my_address, search_id)
      end 
    end

    { "value" => nil}
  end

  add_method 'Container.get_itemavailability' do |ip_address, search_id|

        @is_present = Searchdb.find(search_id)

        if @is_present != nil
          @server1 = XMLRPC::Client.new(@is_present.buyeripaddress, "/items?results=#ip_address&category=#@is_present.category&searchstring=#@is_present.searchquery", 3000)
          @server1.call("index")
          { "value" => nil}
        else

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

require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.method_name' do |category|
   
     @myvar = Sellerring.where("category = ?", category).order("updated_at asc").first 
     @myvar.updated_at = DateTime.now  
     @myvar.save 
 
    { "value" => @myvar.ipaddress }
  end



  add_method 'Container.get_sellerorigin' do |search_string, category_name, ip_address|

    @request = Searchdb.new 
    @request.buyeripaddress = ip_address
    @request.searchquery = search_string
    @request.category = category_name
    @request.save

    @search_id = Searchdb.where("category = :ct AND buyeripaddress = :it AND searchquery = :sq ", {:ct => category_name, :it => ip_address, :sq => search_string})
    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{params[:search]}%", cookies[:CURRCATEGORY]])
    @ip_address = IPSocket.getaddress(Socket.gethostname)

      if @items == nil
        @neighbours = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"}) 
 
        @neighbours.length.times do |i|
          @sucessor = @neighbours[i].ipaddress

          @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3003)
          @server1.call2_async("Container.get_sellerip", search_string,category_name, @ip_address, @search.id)
          { "value" => nil}
        end
        
      else
        { "value" => @ip_address, "search" => search_string, "category" => category_name }
      end
  end

  add_method 'Container.get_sellerip' do |search_string, category_name, ip_address, search_id|

    @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{params[:search]}%", cookies[:CURRCATEGORY]])
    @my_address = IPSocket.getaddress(Socket.gethostname)

      if @items == nil
        @neighbours = Sellerring.where("category = :ct AND iptype = :it", {:ct => category_name, :it => "successor"})

        @neighbours.length.times do |i|
          @sucessor = @neighbours[i].ipaddress
          
          @server1 = XMLRPC::Client.new(@successor, "/api/xmlrpc", 3004)
          @server1.call("Container.get_sellerip", search_string,category_name, ip_address)
          { "value" => nil}
        end
        
      else
          @server1 = XMLRPC::Client.new(ip_address, "/api/xmlrpc", 3002)
          @server1.call2_async("Container.get_itemavailability", @my_address, search_id)
          { "value" => nil}
      end 

  end

  add_method 'Container.get_itemavailability' do |ip_address, search_id|

        @is_present = Searchdb.find(search_id)

        if @is_present != nil
          @server1 = XMLRPC::Client.new(@is_present.buyeripaddress, "/api/xmlrpc", 3000)
          @server1.call("Container.get_sellerip", search_string,category_name, ip_address)
          { "value" => nil}
        else

        end
    end
           
end

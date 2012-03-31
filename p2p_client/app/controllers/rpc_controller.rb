require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.method_name' do
    { "value" => "hi from the seller" }
  end

  add_method 'Container.get_sellerip (search_string)' do

    @items = Item.find(:all, :conditions => ['title LIKE ?', "%#{params[:search]}%"])
      if @items == nil
        @neighbours = Ipaddress.find(:all)
 
        @neighbours.length.times do |i|
          @sucessor = @biddings[i]

          @server1 = XMLRPC::Client.new(successor, "/api/xmlrpc", 3002)
          @value1 = server1.call("Container.get_sellerip", search_string)
        end
        
      else
        @ip_address = IPSocket.getaddress(Socket.gethostname)
        { "value" => @ip_address }
      end


  end

end

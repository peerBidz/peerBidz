require 'xmlrpc/server'
require 'xmlrpc/client'
require 'socket'

class RpcController < ApplicationController

 exposes_xmlrpc_methods

  add_method 'Container.putRingInfo' do |address,successor,predecessor,category,is_seller|

        # Delete these entries before we proceed
        
	@check_ip = Sellerring.where("ip = ? and category = ?", address, category)
        if is_seller == "t"
    	if @check_ip.count != 0
		if @check_ip.first.predecessor != predecessor
			Sellerring.delete("ip = ? and category = ?", predecessor, category )
		elsif @check_ip.first.successor != successor
			Sellerring.delete("ip = ? and category = ?", successor, category )
		end
		@check_ip.first.delete	
	end
        end
        # add the entries
        myentry = Sellerring.new
        myentry.ip = address
        myentry.successor = successor
        myentry.predecessor = predecessor
        myentry.category = category
        myentry.is_seller = is_seller
        myentry.save

        if is_seller == "t"
		puts "its coming to this snippet"
                @predecessor = Sellerring.where("ip = ? and is_seller = ? and category = ?",predecessor,is_seller,category)
                if @predecessor.count != 0
                  @predecessor.first.successor = address
	          @predecessor.first.save
                end

                @successor = Sellerring.where("ip = ? and is_seller = ? and category = ?",successor,is_seller,category)
                if @successor.count != 0
                  @successor.first.predecessor = address
		  @successor.first.save
                end 
        end

        { "value" => "0" }
  end

  add_method 'Container.removeseller' do |address, category|
        myentry = Sellerring.where("ip = ? and is_seller = 't' and category = ?", address, category)
        @predecessor = Sellerring.where("ip = ? and is_seller = 't' and category = ?", myentry.predecessor, category)
        @successor = Sellerring.where("ip = ? and is_seller = 't' and category = ?", myentry.successor, category)
        @predecessor.successor = @successor.ip
        @successor.predecessor = @predecessor.ip
        myentry.delete
        { "value" => "0" }
  end

end

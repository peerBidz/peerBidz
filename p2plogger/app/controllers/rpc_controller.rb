require 'xmlrpc/server'
require 'xmlrpc/client'
require 'socket'

class RpcController < ApplicationController

 exposes_xmlrpc_methods

  add_method 'Container.putRingInfo' do |address,successor,predecessor,category,is_seller|

        # Delete these entries before we proceed
        Sellerring.delete_all("ip = ?", address) 

        # add the entries
        myentry = Sellerring.new
        myentry.ip = address
        myentry.successor = successor
        myentry.predecessor = predecessor
        myentry.category = category
        myentry.is_seller = is_seller
        myentry.save

        
        if is_seller == "t"
                @predecessor = Sellerring.where("ip = ? and is_seller = ? and category = ?",predecessor,is_seller,category)
                @predecessor.successor = address
                @successor = Sellerring.where("ip = ? and is_seller = ? and category = ?",successor,is_seller,category)
                @successor.predecessor = address
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

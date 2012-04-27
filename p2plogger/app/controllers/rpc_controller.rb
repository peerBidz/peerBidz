require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.putRingInfo' do |address,successor,predecessor,category,is_seller|
  	myentry = Sellerring.new	
	myentry.ip = address
	myentry.successor = successor
	myentry.predecessor = predecessor
	myentry.category = category
	myentry.save
	myentry.is_seller = is_seller
	if is_seller = 't'
		@predecessor = Sellerring.where("ip = ? and is_seller = ? and category = ?",predecessor,is_seller,category)
		@predecessor.successor = address
		@successor = Sellerring.where("ip = ? and is_seller = ? and category = ?",successor,is_seller,category)
		@successor.predecessor = address
  	end
  end

end

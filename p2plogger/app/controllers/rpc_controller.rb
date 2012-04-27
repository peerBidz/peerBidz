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
  end

end

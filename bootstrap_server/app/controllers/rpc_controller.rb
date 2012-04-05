require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.is_seller' do |emailaddress|

     @myvar = User.where("email = :et", {:et => emailaddress}) 
     if @myvar.is_seller?
       { "value" => "1" }
     else
       { "value" => "0" }
  end

end

require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.is_seller' do |emailaddress|
     emailaddress.sub("%40", "@");
     @myvar = User.where("email = :et", {:et => emailaddress}).first 
     if @myvar.is_seller == 1
       { "value" => "1" }
     else
       { "value" => "0" }
     end
  end

end

require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.is_seller' do |emailaddress|
     emailaddress.sub("%40", "@");
     myvar = User.where("email = :et", {:et => emailaddress}).first 
     if myvar.is_seller?
       { "value" => "1", "email" => emailaddress }
     else
       { "value" => "0", "email" => emailaddress }
     end
  end

end

require 'xmlrpc/server'
require 'socket'

class RpcController < ApplicationController

  exposes_xmlrpc_methods

  add_method 'Container.get_seller' do |emailaddress|
     emailaddress.sub("%40", "@");
     myvar = User.where("email = :et", {:et => emailaddress}).first 
     if myvar.is_seller?
       { "value" => "1", "email" => emailaddress }
     else
       { "value" => "0", "email" => emailaddress }
     end
  end

  add_method 'Container.getNewParent' do |category|
	@newParent = CategoryMember.where("category = ?", category).order("updated_at asc").first
	if @newParent != nil
		@newParent.updated_at = DateTime.now
		{"value" => @newParent.ipaddress}
	else
		{"value" => "0"}
	end
  end
end

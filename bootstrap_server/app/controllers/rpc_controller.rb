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

  add_method 'Container.getNewParent' do |category, failedseller|
  @newParent = CategoryMembers.where("ipAddress = ?", failedseller)
    if @newParent != nil 
	    if @newParent.count != 0
			@newParent.each do |element|
				element.delete
			end
		end 
    end 
    puts "rchd"
	@newParent = CategoryMembers.where("category = ?", category).order("updated_at asc").first
    if @newParent != nil
	   ip = @newParent.ipAddress	
       @newParent.updated_at = DateTime.now
	   @newParent.save
	   {"value" => ip}
	else
		puts "hey"
	   {"value" => "0"}
	end 
  end

  add_method 'Container.removeDeadSeller' do |failedseller|
  puts "In removeDeadSeller"
  puts failedseller
  @seller = CategoryMembers.where("ipAddress = ?", failedseller)
    if @seller != nil 
	    if @seller.count != 0
			@seller.each do |element|
				element.delete
				puts "Deleted a seller from Cat Mem"
			end
		end 
    end 
	{"value" => "0"}
  end
end

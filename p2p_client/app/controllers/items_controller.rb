require 'time_diff'
require 'date'
require "xmlrpc/client"
require 'socket'
require 'rexml/rexml'
require 'rexml/document'


class ItemsController < ApplicationController
	# GET /items
	# GET /items.xml
	def index
    @my_address = Mydata.first.localaddress 
	if params[:search]
		##### Clear the Searchresults Database
		Searchresults.delete_all
		@search_string = params[:search]

		##### Search for your parent for the category in Ipaddress table 
		@sellerIPAddress = Ipaddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parent"}).first
		
		if @sellerIPAddress != nil
			begin
				##### If parent seller for the category exists in Ipaddress table contact parent to start search
				@server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
				@ip_address = @server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
				if @ip_address["value"] != "0"
					##### If parent seller resturned a search result store in Searchresults table	
					@dbvalue = Searchresults.new
					@dbvalue.search_string = @ip_address["search"]
					@dbvalue.category = @ip_address["category"]
					@dbvalue.ipaddress = @ip_address["value"]
					@dbvalue.returned_string = @ip_address["returnedstring"] 
					@dbvalue.save
				end
			rescue
				##### Parent/origin seller did not respond. Lookup if parentbackup present
				@backupParent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parentbackup"}).first
				if @backupParent != nil
					##### Parentbackup present. Delete parent entry from Ipaddress table. Change parentbackup type to parent
					deadParentIp = @sellerIPAddress.ipaddress
					@sellerIPAddress.delete
					@backupParent.iptype = "parent"
					@backupParent.save
					begin
						##### RPC to old parentbackup (now your parent) and get a new parentbackup from it	
						@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
						@newBackup = @server1.call("Container.parentDeathSwitch", cookies[:CURRCATEGORY], deadParentIp)
						if @newBackup["value"] != nil
							if @newBackup["value"] != "0"	
								##### New parent backup was returned. Add it to Ipaddress table
								@newBackupEntry = Ipaddress.new
								@newBackupEntry.iptype = "parentbackup"
								@newBackupEntry.ipaddress = @newBackup["value"]
								@newBackupEntry.category = @backupParent.category
								@newBackupEntry.save
							end
						end
					rescue
						##### Parent and backup were both dead.Contacting bootstrap
						@myBoot = Sellerring.where("iptype= ?", "bootstrap").first 
						if @myBoot != nil
							##### Ask bootstrap to delete your deadParent seller from Catgeory Members
							@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
							Thread.new {
								@ret = @server1.call2_async("Container.removeDeadSeller", deadParentIp)
							}
							##### Ask bootstrap for a new parent and request to delete your backupParent from Cateory Members
							@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
							@newParent = @server1.call("Container.getNewParent", cookies[:CURRCATEGORY], @backupParent.ipaddress)
							if @newParent["value"] != nil
								if @newParent["value"] != "0"
									##### Bootstrap returned a new parent. Save the entry in Ipaddress table
									@backupParent.ipaddress = @newParent["value"]
									@backupParent.save
								else
									##### Bootstrap does not have anyone else in category members. Delete entry from Ipaddress table
									@backupParent.delete
								end
							end
							if @newParent["value"] != nil
								if @newParent["value"] != "0"
									##### Bootstrap returned a new parent. Contact it for a new backup
									@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
									@newBackup = @server1.call("Container.getBackupParent", cookies[:CURRCATEGORY])
									if @newBackup["value"] != nil
										if  @newBackup["value"] != "0"
											##### The new parent returned a new backup parent. Save in Ipaddress table
											@newBackupEntry = Ipaddress.new
											@newBackupEntry.iptype = "parentbackup"
											@newBackupEntry.ipaddress = @newBackup["value"]
											@newBackupEntry.category = @backupParent.category
											@newBackupEntry.save
										end
									end
								end
							end
						end #### end of @myBoot != nil
					end  ##### end of rescue for backupparent being dead 
				
				else   ##### Backup parent was not present in buyer's Ipaddress table
					##### Contact bootstrap for getting a new parent
    				@myBoot = Sellerring.where("iptype = 'bootstrap'").first 
					if @myBoot != nil
						@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
						ip = @sellerIPAddress.ipaddress 	
						currcat = cookies[:CURRCATEGORY]
						@newParent = @server1.call("Container.getNewParent", currcat, ip)
						if @newParent["value"] != "0"
							##### Bootstrap returned a new parent. Save entry in Ipaddress table	
							@sellerIPAddress.ipaddress = @newParent["value"]
							@sellerIPAddress.save
							begin
								##### Contact new parent returned by bootstrap for a backup parent
								@server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
								@newBackup = @server1.call("Container.getBackupParent", cookies[:CURRCATEGORY])
							    if @newBackup != nil
								    @newBackupEntry = Ipaddress.new
							        @newBackupEntry.iptype = "parentbackup"
							        @newBackupEntry.ipaddress = @newBackup["value"]
							        @newBackupEntry.category = @backupParent.category
							        @newBackupEntry.save
							    	#todo
								@server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
								@ip_address = @server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
                        					if @ip_address["value"] != "0"
								##### Parent returned search results
									@dbvalue = Searchresults.new
									@dbvalue.search_string = @ip_address["search"]
									@dbvalue.category = @ip_address["category"]
									@dbvalue.ipaddress = @ip_address["value"]
									@dbvalue.returned_string = @ip_address["returnedstring"] 
									@dbvalue.save
								end
							    end
							rescue
								puts "new parent from bootstrap also unavailable. Do not wish to support further fault tolerance"
							end
						else
							##### Bootstrap did not return any new parent. Delete parent entry from Ipaddress table
							@sellerIPAddress.delete
						end
					end ##### ends @myBoot != nil
				end ##### ends if-else for @backupParent != nil	
			end  ##### Ends begin-rescue for parent/origin seller not responding
		else	##### No parent present in Ipaddress table
			@myBoot = Sellerring.where("iptype= ?", "bootstrap").first 
			if @myBoot != nil
				##### Contact bootstrap for parent/origin seller
				@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
        		@newParent = @server1.call("Container.getNewParent", cookies[:CURRCATEGORY], "0.0.0.0")
				if @newParent["value"] != "0"
					##### Save parent returned by bootstrap in Ipaddress table
					@sellerIPAddress = Ipaddress.new
				    @sellerIPAddress.iptype = "parent"	
					@sellerIPAddress.ipaddress = @newParent["value"]
					@sellerIPAddress.category = cookies[:CURRCATEGORY]
					@sellerIPAddress.save
					begin
						##### Contact parent for backup parent
						@server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
        				@newBackup = @server1.call("Container.getBackupParent", cookies[:CURRCATEGORY])
						if @newBackup["value"] != "0" 
							##### Backup parent returned by parent. Save in Ipaddress table
							@newBackupEntry = Ipaddress.new
							@newBackupEntry.iptype = "parentbackup"
							@newBackupEntry.ipaddress = @newBackup["value"]
							@newBackupEntry.category = @backupParent.category
							@newBackupEntry.save
						end
						##### Contact parent/origin seller to start search
						@server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
						@ip_address = @server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
                        if @ip_address["value"] != "0"
							##### Parent returned search results
							@dbvalue = Searchresults.new
							@dbvalue.search_string = @ip_address["search"]
							@dbvalue.category = @ip_address["category"]
							@dbvalue.ipaddress = @ip_address["value"]
							@dbvalue.returned_string = @ip_address["returnedstring"] 
							@dbvalue.save
						end
					rescue
						puts "New parent from bootstrap also failed. Do no support more fault tolerance"
					end
				end ##### ends @newParent[value] != "0"
			end ##### ends @myBoot != null
		end ##### ends if-else parent present in Ipaddress table

    elsif params[:browse]
    #@items = Item.find(:all, :conditions => ['category_id LIKE ?', "#{params[:browse]}"])
    #@items = Item.find_all_by_category_id("#{params[:browse]}")

    cookies[:CURRCATEGORY] = {
     :value => params[:browse],
     :expires => 1.year.from_now
    }


    myBoot = Sellerring.where("iptype= ?", "bootstrap").first 

    @userinfo = Mydata.first
    if @userinfo != nil
	if @userinfo.is_seller?
		puts "i am a seller"
      	
		
		@checkcategory = Sellerring.where("category = :ct AND iptype = :pt", {:ct => params[:browse], :pt => "successor"})
  
      		if @checkcategory.count == 0
			puts "no successor"
        		@successorip = params[:parent]
        		@category = params[:browse]
			if params[:parent] != nil
				if params[:parent] != "0"
					puts "adding a succesor"
        				puts params[:parent]
					@mydb = Sellerring.new
        				@mydb.ipaddress = @successorip
        				@mydb.category = @category
        				@mydb.iptype = 'successor'
        				@mydb.save
				end
			end
      		else
        		@checkcategory.each {|f| @successorip = f.ipaddress }
      		end

      		 @checkcategory = Sellerring.where("category = :ct AND iptype = :pt", {:ct => params[:browse], :pt => "predecessor"})

      		if @successorip != nil
			if @successorip != "0"
				puts "successor isn't nil"
				if @checkcategory.count == 0
					puts "no predecessor"
        				@serverPre = XMLRPC::Client.new(params[:parent], "/api/xmlrpc", 3000)
        				
					predecessorip = 0
					backupSuccessor = 0
					begin
						@sellervalue = @serverPre.call("Container.extendSellerRing", @userinfo.localaddress, params[:browse])
        					predecessorip = @sellervalue["value"]
						backupSuccessor = @sellervalue["backup_successor"]
					rescue
						puts "Exception caught. Bad IP address"
					end
					if predecessorip != 0
        					@category = params[:browse]
        					@mydb = Sellerring.new
        					@mydb.ipaddress = predecessorip
        					@mydb.category = @category
        					@mydb.iptype = 'predecessor'
        					@mydb.save
        					@mypred = XMLRPC::Client.new(predecessorip, "/api/xmlrpc", 3000)
        					@backupPred = @mypred.call("Container.updateSuccessor", @userinfo.localaddress, @category)
					
						if @backupPred["value"] != 0
        						@category = params[:browse]
        						@mydb = Sellerring.new
        						@mydb.ipaddress = @backupPred["value"]
        						@mydb.category = @category
        						@mydb.iptype = 'backup_predecessor'
        						@mydb.save
						end
					else	
        					@category = params[:browse]
        					@mydb = Sellerring.new
        					@mydb.ipaddress = @successorip
        					@mydb.category = @category
        					@mydb.iptype = 'predecessor'
        					@mydb.save
					end
					if backupSuccessor != 0
        					@category = params[:browse]
        					@mydb = Sellerring.new
        					@mydb.ipaddress = backupSuccessor
        					@mydb.category = @category
        					@mydb.iptype = 'backup_successor'
        					@mydb.save
					end
      				end     
			end
     		end
       
   	else

      	@checkcategory = Ipaddress.find_all_by_category(params[:browse])
  		puts "buyer"
      	if (@checkcategory.count == 0)
			if params[:parent] != "0"
        		@parentip = params[:parent]
        		@category = params[:browse]
        		@mydb = Ipaddress.new
        		@mydb.ipaddress = @parentip
        		@mydb.category = @category
        		@mydb.iptype = 'parent'
        		@mydb.save
				puts "saved parent"
			end
  		end
		@is_parentpresent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => params[:browse], :it => "parent"})
		if @is_parentpresent != nil
			if @is_parentpresent.count != 0
				@is_parentbackuppresent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => params[:browse], :it => "parentbackup"})
				puts "Entered here"
				if @is_parentbackuppresent != nil
					if @is_parentbackuppresent.count == 0
						puts "No backup parent found"
						@server1 = XMLRPC::Client.new(@is_parentpresent.first.ipaddress, "/api/xmlrpc", 3000)
						begin
							@sellervalue = @server1.call("Container.getBackupParent", params[:browse])
							puts "made a call to parent" 
							if @sellervalue != nil
								if @sellervalue["value"] != "0"
									puts "Adding backup parent to db"
									@newdata = Ipaddress.new
									@newdata.ipaddress = @sellervalue["value"]
									@newdata.iptype = 'parentbackup'
									@newdata.category = params[:browse]
									@newdata.save
								end
							end
						rescue	
							puts "Rescue for buyer"
						end
					end
				end
			end
		end
	end
end

    else
	    @items = Searchresults.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
      format.js
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @item = Searchresults.where("id = ? ", params[:id]).first

    @test = cookies[:CURRCATEGORY] 
    puts @test
    puts @item.returned_string
    if @item != nil
      @server1 = XMLRPC::Client.new(@item.ipaddress, "/api/xmlrpc", 3000)
      @iteminfo = @server1.call("Container.getItemInfo", cookies[:CURRCATEGORY], @item.returned_string)
      #@days = @time_diff_components[:week].to_i * 7  + @time_diff_components[:day]
    end
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.js
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { render :action => "initauction"}
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item, :notice => 'Item Successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])

    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end

end

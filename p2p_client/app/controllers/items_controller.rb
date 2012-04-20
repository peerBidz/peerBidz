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
#      @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{params[:search]}%", cookies[:CURRCATEGORY]])
      # Lets clear the Searchresults DB
      Searchresults.delete_all

      @search_string = params[:search]

      @sellerIPAddress = Ipaddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parent"}).first

if @sellerIPAddress != nil
        @server1 = XMLRPC::Client.new(@sellerIPAddress.ipaddress, "/api/xmlrpc", 3000)
        begin
		@ip_address = @server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
        	if @ip_address["value"] != "0"
          		@dbvalue = Searchresults.new
          		@dbvalue.search_string = @ip_address["search"]
          		@dbvalue.category = @ip_address["category"]
          		@dbvalue.ipaddress = @ip_address["value"]
          		@dbvalue.returned_string = @ip_address["returnedstring"] 
          		@dbvalue.save
        	end
	rescue
		puts "Exception caught. Seller IP is bad."
		@backupParent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parentbackup"}).first

		if @backupParent != nil
			@sellerIPAddress.delete
			@backupParent.iptype = "parent"
			@backupParent.save
        		begin 
				@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
        			@newBackup = @server1.call("Container.getBackupParent", params[:browse])
				
				if @newBackup["value"] != nil
					@newBackupEntry = Ipaddress.new
					@newBackupEntry.iptype = "parentbackup"
					@newBackupEntry.ipaddress = @newBackup["value"]
					@newBackupEntry.category = @backupParent.category
					@newBackupEntry.save
				end
    			rescue
    				@myBoot = Sellerring.where("iptype= ?", "bootstrap").first 
				if @myBoot != nil
					@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
        				@newParent = @server1.call("Container.getNewParent", params[:browse])
					if @newParent["value"] != nil
						@backupParent.ipaddress = @newParent["value"]
						@backupParent.save
					end

						
					@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
        				@newBackup = @server1.call("Container.getBackupParent", params[:browse])
				
					if @newBackup["value"] != nil
						@newBackupEntry = Ipaddress.new
						@newBackupEntry.iptype = "parentbackup"
						@newBackupEntry.ipaddress = @newBackup["value"]
						@newBackupEntry.category = @backupParent.category
						@newBackupEntry.save
					end
				end
				
			end
			
		else
			puts "contact bootstrap"
    				@myBoot = Sellerring.where("iptype= ?", "bootstrap").first 
				if @myBoot != nil
					@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
        				@newParent = @server1.call("Container.getNewParent", params[:browse])
					if @newParent["value"] != nil
						@backupParent.ipaddress = @newParent["value"]
						@backupParent.save
					end

					# Contacting bootstrap for new parent because no backup exists	
					begin
						@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
        					@newBackup = @server1.call("Container.getBackupParent", params[:browse])
					rescue
						puts "new parent from bootstrap is unavailable"
					end

					if @newBackup["value"] != nil
						@newBackupEntry = Ipaddress.new
						@newBackupEntry.iptype = "parentbackup"
						@newBackupEntry.ipaddress = @newBackup["value"]
						@newBackupEntry.category = @backupParent.category
						@newBackupEntry.save
					end
				end
		end
	end
else
			puts "contact bootstrap"
    				@myBoot = Sellerring.where("iptype= ?", "bootstrap").first 
				if @myBoot != nil
					@server1 = XMLRPC::Client.new(@myBoot.ipaddress, "/api/xmlrpc", 3001)
        				@newParent = @server1.call("Container.getNewParent", params[:browse])
					if @newParent["value"] != nil
						@backupParent.ipaddress = @newParent["value"]
						@backupParent.save
					end

					# Contacting bootstrap for new parent because no backup exists	
					begin
						@server1 = XMLRPC::Client.new(@backupParent.ipaddress, "/api/xmlrpc", 3000)
        					@newBackup = @server1.call("Container.getBackupParent", params[:browse])
					rescue
						puts "new parent from bootstrap is unavailable"
					end

					if @newBackup["value"] != nil
						@newBackupEntry = Ipaddress.new
						@newBackupEntry.iptype = "parentbackup"
						@newBackupEntry.ipaddress = @newBackup["value"]
						@newBackupEntry.category = @backupParent.category
						@newBackupEntry.save
					end
				end
end

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
			if params[:parent] != 0
        			@parentip = params[:parent]
        			@category = params[:browse]
        			@mydb = Ipaddress.new
        			@mydb.ipaddress = @parentip
        			@mydb.category = @category
        			@mydb.iptype = 'parent'
        			@mydb.save
				puts "saved parent"
			end
      		else
        		@checkcategory.each {|f| @parentip = f.ipaddress }
      		end

      		@is_parentbackuppresent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => params[:browse], :it => "parentbackup"})
      
     	 	if @is_parentbackuppresent.length == 0
        		@server1 = XMLRPC::Client.new(@parentip, "/api/xmlrpc", 3000)
        		@sellervalue = @server1.call("Container.getBackupParent", params[:browse])
    
        	if @sellervalue.length != 0
                  if @sellervalue["value"] != "0"
          		@newdata = Ipaddress.new
          		@newdata.ipaddress = @sellervalue["value"]
          		@newdata.iptype = 'parentbackup'
          		@newdata.category = params[:browse]
          		@newdata.save
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

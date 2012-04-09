require 'time_diff'
require 'date'
require "xmlrpc/client"
require 'socket'


class ItemsController < ApplicationController

  # GET /items
  # GET /items.xml
  def index
      @my_address = UDPSocket.open {|s| s.connect('65.59.196.211', 1); s.addr.last } 
    if params[:search]
#      @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{params[:search]}%", cookies[:CURRCATEGORY]])
      # Lets clear the Searchresults DB
      Searchresults.delete_all

      @search_string = params[:search]

      @sellerIPAddress = Ipaddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parent"})

      @sellerIPAddress.length.times do |i|
        @server1 = XMLRPC::Client.new(@sellerIPAddress[i].ipaddress, "/api/xmlrpc", 3000)
        @ip_address = @server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
        if @ip_address["value"] != nil
          @dbvalue = Searchresults.new
          @dbvalue.search_string = @ip_address["search"]
          @dbvalue.category = @ip_address["category"]
          @dbvalue.ipaddress = @ip_address["value"]
          @dbvalue.save
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
        			@sellervalue = @serverPre.call("Container.sellermethod", @userinfo.localaddress, params[:browse])
        			@predecessorip = @sellervalue["value"]
				if @predecessorip != 0
        				@category = params[:browse]
        				@mydb = Sellerring.new
        				@mydb.ipaddress = @predecessorip
        				@mydb.category = @category
        				@mydb.iptype = 'predecessor'
        				@mydb.save
        				@mypred = XMLRPC::Client.new(@predecessorip, "/api/xmlrpc", 3000)
        				@mypred.call_async("Container.updateSuccessor", @userinfo.localaddress, @category)
					
				else
        				@category = params[:browse]
        				@mydb = Sellerring.new
        				@mydb.ipaddress = @successorip
        				@mydb.category = @category
        				@mydb.iptype = 'predecessor'
        				@mydb.save
				end
      			end     
		end
     	end
	end
       
   	else

      		@checkcategory = Ipaddress.find_all_by_category(params[:browse])
  		puts "buyer"
      		if (@checkcategory.count == 0)
        		@parentip = params[:parent]
        		@category = params[:browse]
        		@mydb = Ipaddress.new
        		@mydb.ipaddress = @parentip
        		@mydb.category = @category
        		@mydb.iptype = 'parent'
        		@mydb.save
			puts "saved parent"
      		else
        		@checkcategory.each {|f| @parentip = f.ipaddress }
      		end

      		@is_parentbackuppresent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => params[:browse], :it => "parentbackup"})
      
     	 	if @is_parentbackuppresent.length == 0
        		@server1 = XMLRPC::Client.new(@parentip, "/api/xmlrpc", 3000)
        		@sellervalue = @server1.call("Container.method_name", params[:browse])
    
        	if @sellervalue.length != 0
          		@newdata = Ipaddress.new
          		@newdata.ipaddress = @sellervalue["value"]
          		@newdata.iptype = 'parentbackup'
          		@newdata.category = params[:browse]
          		@newdata.save
        	end
      	end
   end


   elsif params[:results]
      @ipaddress = params[:results]
      @category = params[:category]
      @searchstring = params[:searchstring]

      @dbvalue = Searchresults.new
      @dbvalue.search_string = @searchstring
      @dbvalue.category = @category
      @dbvalue.ipaddress = @ipaddress
      @dbvalue.save

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
    @item = Item.find(params[:id])
    @bidding = Bidding.new
    @highest_bid = @item.bidding.find(:first, :order => 'bid_amount DESC')

    @time_diff_components = Time.diff(Time.now.utc, @item.expires_at.utc)
    #@days = @time_diff_components[:week].to_i * 7  + @time_diff_components[:day]
    
    
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

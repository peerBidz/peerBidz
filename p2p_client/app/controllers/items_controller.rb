require 'time_diff'
require 'date'
require "xmlrpc/client"
require 'socket'


class ItemsController < ApplicationController

  # GET /items
  # GET /items.xml
  def index
    if params[:search]
#      @items = Item.find(:all, :conditions => ['title LIKE ? AND category = ?', "%#{params[:search]}%", cookies[:CURRCATEGORY]])
      @search_string = params[:search]
      @my_address = IPSocket.getaddress(Socket.gethostname)

      @sellerIPAddress = Ipadddress.where("category = :ct AND iptype = :it", {:ct => cookies[:CURRCATEGORY], :it => "parent"})

      @sellerIPAddress.length.times do |i|
        @server1 = XMLRPC::Client.new(@sellerIPAddress[i].ipaddress, "/api/xmlrpc", 3002)
        @ip_address = server1.call("Container.get_sellerorigin", @search_string, cookies[:CURRCATEGORY], @my_address)
      end

    elsif params[:browse]
    #@items = Item.find(:all, :conditions => ['category_id LIKE ?', "#{params[:browse]}"])
    #@items = Item.find_all_by_category_id("#{params[:browse]}")

    cookies[:CURRCATEGORY] = {
     :value => params[:browse],
     :expires => 1.year.from_now
    }

    @checkcategory = Ipaddress.find_all_by_category(params[:browse]) 
   
    if (@checkcategory.length == 0)
      @parentip = params['parent']
      @category = params['browse'] 
      @mydb = Ipaddress.new 
      @mydb.ipaddress = @parentip
      @mydb.category = @category
      @mydb.iptype = 'parent' 
      @mydb.save 
    else
      @checkcategory.each {|f| @parentip = f.ipaddress }
    end

#    if current_user.is_seller?
       
#    else
      @is_parentbackuppresent = Ipaddress.where("category = :ct AND iptype = :it", {:ct => params[:browse], :it => "parentbackup"})
      
      if @is_parentbackuppresent.length == 0
        @server1 = XMLRPC::Client.new(@parentip, "/api/xmlrpc", 3002)
        @sellervalue = @server1.call("Container.method_name", params[:browse])
    
        if @sellervalue.length != 0
          @newdata = Ipaddress.new
          @newdata.ipaddress = @sellervalue["value"]
          @newdata.iptype = 'parentbackup'
          @newdata.category = params[:browse]
          @newdata.save
        end
      end
#    end

    #@values = "%#{params[:browse]}%"       for debugging purpose WJ
    else
    @items = Item.all
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

  def initauction
     
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

require 'time_diff'
require 'date'
require "xmlrpc/client"
require 'socket'


class ItemsController < ApplicationController

  # GET /items
  # GET /items.xml
  def index
    if params[:search]
      @items = Item.find(:all, :conditions => ['title LIKE ?', "%#{params[:search]}%"])
      @search_string = params[:search]

      if @items == nil
        @sellerIPAddress = '127.0.0.1'

        @server1 = XMLRPC::Client.new(successor_1, "/api/xmlrpc", 3001)
        @ip_address = server1.call("Container.get_sellerip", @search_string)
      else
        @ip_address = IPSocket.getaddress(Socket.gethostname)
      end

    elsif params[:browse]
    #@items = Item.find(:all, :conditions => ['category_id LIKE ?', "#{params[:browse]}"])
    #@items = Item.find_all_by_category_id("#{params[:browse]}")
    @tests = CategoryMembers.where("category = ?", "#{params[:browse]}")

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
        format.html { redirect_to(@item, :notice => 'Item successfully created.') }
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

  def add_to_watch_list
    @item = Item.find(params[:id])
    Watchlist.create!(:user_id => current_user.id , :item_id => @item.id)

    respond_to do |format|
      format.html { redirect_to(item_path, :notice => 'Item successfully added to your watch list.') }
      format.xml  { render :xml => @item }
    end
  end

  def remove_from_watch_list
    @item = Item.find(params[:id])
    @watch = Watchlist.find_by_user_id_and_item_id(current_user.id, @item.id)
    @watch.destroy

    respond_to do |format|
      format.html { redirect_to(item_path, :notice => 'Item successfully removed from your watch list.') }
      format.xml  { render :xml => @item }
    end
  end

end

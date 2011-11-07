class BiddingsController < ApplicationController
  def create

    @bidding = Bidding.new(params[:bidding])

    #saving old highest bid so we can notify the old leader he has been outbid
    @old_highest_bid = Bidding.find(:first, :conditions => ["item_id IN (?)", @bidding.item_id] , :order => 'bid_amount DESC')

    if @bidding.save
     @current_highest_bid = @bidding.bid_amount
     @bid_notification_msg = "Congrats! You have successfully placed the bid"

     #notify older leader he has been outbid. notify seller there is a new bid on his item.
     if(!@old_highest_bid.nil? && @old_highest_bid.user_id != @bidding.user_id)
      Notification.create(:user_id=>@old_highest_bid.user_id, :item_id=>@bidding.item_id, :message=>"outbid", :delivered=>"false")
     end
     Notification.create(:user_id=>Item.find(@bidding.item_id).seller_id, :item_id=>@bidding.item_id, :message=>"new_bid", :delivered=>"false")

    elsif(!@bidding.errors.empty?)
      @bid_notification_msg = "Sorry, your bid was not successful. Please bid higher than the current price"
    end
    respond_to do |format|
      format.xml  { render :xml => @bidding }
      format.js
    end
  end

  def new
    @bidding = Bidding.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bidding }
    end
  end

end

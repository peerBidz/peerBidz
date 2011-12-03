class BiddingsController < ApplicationController
  def create

    @bidding = Bidding.new(params[:bidding])

    #saving old highest bid so we can notify the old leader he has been outbid
    @old_highest_bid = Bidding.find(:first, :conditions => ["item_id IN (?)", @bidding.item_id] , :order => 'bid_amount DESC')

    if @bidding.save
      @current_highest_bid = @bidding.bid_amount
      @bid_notification_msg = "Congrats! You have successfully placed the bid"

      #notify older leader he has been outbid.
      if (!@old_highest_bid.nil? && @old_highest_bid.user_id != @bidding.user_id)
      #Notification for the user who was outbid
      @msg = "You have been outbid on: " + Item.find(@bidding.item_id).title
      Notification.create(:user_id=>@old_highest_bid.user_id, :item_id=>@bidding.item_id, :message=>@msg, :delivered=>"false", :notification_type => 'O')
      end
    #Notification for the seller
    @msg =  "There is a new bid on your item (" + Item.find(@bidding.item_id).title + ") for $" + @current_highest_bid.to_s + " !"
    Notification.create(:user_id=>Item.find(@bidding.item_id).seller_id, :item_id=>@bidding.item_id, :message=>@msg, :delivered=>"false", :notification_type => 'N')

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

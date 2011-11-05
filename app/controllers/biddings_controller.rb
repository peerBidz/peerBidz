class BiddingsController < ApplicationController
  def create
    @bidding = Bidding.new(params[:bidding])
    if @bidding.save
    @notice = "You have successfully placed the bid"
    Notification.create(:user_id=>@bidding.user_id, :item_id=>@bidding.item_id, :message=>"outbid", :delivered=>"false")
    Notification.create(:user_id=>Item.find(@bidding.item_id).seller_id, :item_id=>@bidding.item_id, :message=>"new_bid", :delivered=>"false")

   @bid_notification_msg = "Congrats! You have successfully placed the bid"
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

class PagesController < ApplicationController

  def home
#$BOOTSTRAPSERVER = "100.0.0.1"
    session[:BOOTSTRAPSERVER] = "test"
    @title = "Home"
    @items = Item.all
  end

  def myaccount
    @title = "My PeerBidz"
  end

  def items
    @title = "Items"
  end

  def categories
  end

  def payment
    @title = "Payment Page"
  end

end

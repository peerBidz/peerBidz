class PagesController < ApplicationController

  def home
    @title = "Home"
    @items = Item.all
  end

  def myaccount
    @title = "My BestBay"
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

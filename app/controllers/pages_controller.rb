class PagesController < ApplicationController

  def home
    @title = "Home"
    @items = Item.all
  end

  def contacts
    @title = "Order"
  end

  def items
    @title = "Items"
  end

  def categories

  end

end

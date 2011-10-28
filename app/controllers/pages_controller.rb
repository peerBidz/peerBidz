class PagesController < ApplicationController

  def home
    @title = "Home"
    @items = Item.all
  end

  def contact
    @title = "Contact"
  end

  def items
    @title = "Items"
  end

  def categories

  end

end

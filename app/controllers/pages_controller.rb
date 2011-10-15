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

  def adminHome
      @items = Item.all
      @users = User.all
  end

end

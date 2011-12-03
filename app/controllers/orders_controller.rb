class OrdersController < ApplicationController
  def new
    @order = Order.new
    @cart = current_cart
  end

  def create
    @order = current_cart.build_order(params[:order])

    if @order.save
      if @order.purchase
        render :action => "success"
      else
        render :action => "review"
      end
    else
      render :action => 'new'
    end
  end

  def index
    @orders = Order.find(:all)
  end

  def review
     @order = Order.find(params[:id])

  end
end
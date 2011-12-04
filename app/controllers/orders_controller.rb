class OrdersController < ApplicationController
  def new
    @order = Order.new
    @cart = current_cart
  end

  def create
    @order = current_cart.build_order(params[:order])
    flash[:notice] = "Thank you for your payment. We will process it in one business day! Have a great day :-)"

    if @order.save
      if @order.purchase
        render :action => "success"
      else
        render :action => "review"
      end
    else
      render :action => 'review'
    end
  end

  def index
     @orders = Order.find(:all)
  end

  def review
     @order = Order.find(params[:id])

  end
end
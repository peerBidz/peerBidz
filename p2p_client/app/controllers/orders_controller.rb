class OrdersController < ApplicationController
  def new
    @order = Order.new
    @cart = current_cart
  end

  def create
    @order = current_cart.build_order(params[:order])
    flash[:notice] = "Thank you for your payment. We will process it in one business day! Have a great day :-)"

    @cart = current_cart

    #Create notification for seller to ship item
    @itemsPaid = LineItem.find_all_by_cart_id( @cart.id )

    @itemsPaid.each do |item|
      @msg = Item.find(item.item_id).title+" has received payment and requires shipping"
      Notification.create( :item_id=>item.item_id, :message=>@msg, :delivered=>"false", :notification_type => 'P')  
    end
    #------

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

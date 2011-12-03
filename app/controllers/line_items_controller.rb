class LineItemsController < ApplicationController
  def create
    @item = Item.find(params[:item_id])
    @currentBid = Bidding.find(params[:item_id])
    @line_item = LineItem.create!(:cart => current_cart, :item => @item, :quantity => 1, :unit_price => @currentBid.bid_amount)

    flash[:notice] = "Added #{@item.title} to cart."

    session[:last_product_page] = current_cart_url
    redirect_to current_cart_url
  end

  def destroy
    @line_item = LineItem.find(params[:id])

    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to(current_cart_url) }
      format.xml  { head :ok }
    end
  end
end
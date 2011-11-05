class BiddingsController < ApplicationController
  def create
    @bidding = Bidding.new(params[:bidding])
    if @bidding.save
    @notice = "You have successfully placed the bid"
    elsif(!@bidding.errors.empty?)
    @notice = @bidding.errors
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

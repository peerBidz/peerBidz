class SellerringsController < ApplicationController
  # GET /sellerrings
  # GET /sellerrings.xml
  def index
    @sellerrings = Sellerring.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sellerrings }
    end
  end

  # GET /sellerrings/1
  # GET /sellerrings/1.xml
  def show
    @sellerring = Sellerring.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sellerring }
    end
  end

  # GET /sellerrings/new
  # GET /sellerrings/new.xml
  def new
    @sellerring = Sellerring.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sellerring }
    end
  end

  # GET /sellerrings/1/edit
  def edit
    @sellerring = Sellerring.find(params[:id])
  end

  # POST /sellerrings
  # POST /sellerrings.xml
  def create
    @sellerring = Sellerring.new(params[:sellerring])

    respond_to do |format|
      if @sellerring.save
        format.html { redirect_to(@sellerring, :notice => 'Sellerring was successfully created.') }
        format.xml  { render :xml => @sellerring, :status => :created, :location => @sellerring }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sellerring.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sellerrings/1
  # PUT /sellerrings/1.xml
  def update
    @sellerring = Sellerring.find(params[:id])

    respond_to do |format|
      if @sellerring.update_attributes(params[:sellerring])
        format.html { redirect_to(@sellerring, :notice => 'Sellerring was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sellerring.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sellerrings/1
  # DELETE /sellerrings/1.xml
  def destroy
    @sellerring = Sellerring.find(params[:id])
    @sellerring.destroy

    respond_to do |format|
      format.html { redirect_to(sellerrings_url) }
      format.xml  { head :ok }
    end
  end
end

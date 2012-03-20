class CategoryMembersController < ApplicationController
  # GET /category_members
  # GET /category_members.json
  def index
    @category_members = CategoryMember.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @category_members }
    end
  end

  # GET /category_members/1
  # GET /category_members/1.json
  def show
    @category_member = CategoryMember.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category_member }
    end
  end

  # GET /category_members/new
  # GET /category_members/new.json
  def new
    @category_member = CategoryMember.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category_member }
    end
  end

  # GET /category_members/1/edit
  def edit
    @category_member = CategoryMember.find(params[:id])
  end

  # POST /category_members
  # POST /category_members.json
  def create
    @category_member = CategoryMember.new(params[:category_member])

    respond_to do |format|
      if @category_member.save
        format.html { redirect_to @category_member, notice: 'Category member was successfully created.' }
        format.json { render json: @category_member, status: :created, location: @category_member }
      else
        format.html { render action: "new" }
        format.json { render json: @category_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /category_members/1
  # PUT /category_members/1.json
  def update
    @category_member = CategoryMember.find(params[:id])

    respond_to do |format|
      if @category_member.update_attributes(params[:category_member])
        format.html { redirect_to @category_member, notice: 'Category member was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category_member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /category_members/1
  # DELETE /category_members/1.json
  def destroy
    @category_member = CategoryMember.find(params[:id])
    @category_member.destroy

    respond_to do |format|
      format.html { redirect_to category_members_url }
      format.json { head :no_content }
    end
  end
end

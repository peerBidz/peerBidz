class UsersController < ApplicationController
   # GET /allusers
  # GET /allusers.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

    # GET /users/1
  # GET /users/1.xml
  def show
      @user = User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # GET /users/1/destroy
  def destroy
    sign_out(current_user);
    redirect_to(root_path);
  end
end

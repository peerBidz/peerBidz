class ApplicationsController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @application = Application.new
  end

  def create
    @application = Application.new(params[:application])
    if @application.save
      session[:application_id] = @application.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end

  def edit
    @application = current_application
  end

  def update
    @application = current_application
    if @application.update_attributes(params[:application])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end
end

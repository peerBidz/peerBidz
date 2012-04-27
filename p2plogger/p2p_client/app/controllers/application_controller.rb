class ApplicationController < ActionController::Base
  protect_from_forgery

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  #filter_parameter_logging :card_number, :card_verification

#  @test = "test"
#  session[:BOOTSTRAPSERVER] = @test
  helper_method :my_var

  def my_var
  @test = "test"
  session[:BOOTSTRAPSERVER] = @test
    $support = "192.168.48.200"
  end

  def current_cart

    #session[:cart_id] = nil

    if session[:cart_id]
      @current_cart ||= Cart.find(session[:cart_id])
      session[:cart_id] = nil if @current_cart.purchased_at
    end
    if session[:cart_id].nil?
      @current_cart = Cart.create!
      session[:cart_id] = @current_cart.id
    end
    @current_cart
  end
end

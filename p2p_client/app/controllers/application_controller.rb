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

end

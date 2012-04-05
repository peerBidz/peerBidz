# Load the rails application
require File.expand_path('../application', __FILE__)

#$BOOTSTRAPSERVER = "100.0.1.1"
# Initialize the rails application
BestBay::Application.initialize!


gem "activemerchant", :lib => "active_merchant"

#session[:BOOTSTRAPSERVER] = "192.168.48.200"

require 'spec_helper'

describe "LayoutLinks" do

  it "should have a Home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end

#  it "should have a Contact page at '/contact'" do
#    get '/contact'
#    response.should have_selector('title', :content => "Contact")
#  end

  it "should have an Item page at '/items'" do
    get '/items'
    response.should have_selector('title', :content => "Items")
  end

  it "should have a Register page at '/register'" do
    get '/register'
    response.should have_selector('title', :content => "Register")
  end
#  it "should have a Help page at '/help'" do
#    get '/help'
#    response.should have_selector('title', :content => "Help")
#  end
end

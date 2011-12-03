require 'spec_helper'

describe "orders/show.html.erb" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :first_name => "First Name",
      :last_name => "Last Name",
      :card_type => "Card Type",
      :street => "Street",
      :city => "City",
      :zip => "Zip",
      :state => "State",
      :phone => 1,
      :country => "Country",
      :cart_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/First Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Last Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Card Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Street/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zip/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Country/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

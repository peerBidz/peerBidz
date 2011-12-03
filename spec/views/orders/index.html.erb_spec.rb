require 'spec_helper'

describe "orders/index.html.erb" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
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
      ),
      stub_model(Order,
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
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Card Type".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Street".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

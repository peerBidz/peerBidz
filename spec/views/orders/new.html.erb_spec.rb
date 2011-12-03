require 'spec_helper'

describe "orders/new.html.erb" do
  before(:each) do
    assign(:order, stub_model(Order,
      :first_name => "MyString",
      :last_name => "MyString",
      :card_type => "MyString",
      :street => "MyString",
      :city => "MyString",
      :zip => "MyString",
      :state => "MyString",
      :phone => 1,
      :country => "MyString",
      :cart_id => 1
    ).as_new_record)
  end

  it "renders new order form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => orders_path, :method => "post" do
      assert_select "input#order_first_name", :name => "order[first_name]"
      assert_select "input#order_last_name", :name => "order[last_name]"
      assert_select "input#order_card_type", :name => "order[card_type]"
      assert_select "input#order_street", :name => "order[street]"
      assert_select "input#order_city", :name => "order[city]"
      assert_select "input#order_zip", :name => "order[zip]"
      assert_select "input#order_state", :name => "order[state]"
      assert_select "input#order_phone", :name => "order[phone]"
      assert_select "input#order_country", :name => "order[country]"
      assert_select "input#order_cart_id", :name => "order[cart_id]"
    end
  end
end

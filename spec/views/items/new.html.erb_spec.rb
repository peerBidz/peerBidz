require 'spec_helper'

describe "items/new.html.erb" do
  before(:each) do
    assign(:item, stub_model(Item,
      :title => "MyString",
      :description => "MyString",
      :condition => false,
      :starting_price => "9.99",
      :duration => 1,
      :category_id => 1,
      :seller_id => 1
    ).as_new_record)
  end

  it "renders new item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => items_path, :method => "post" do
      assert_select "input#item_title", :name => "item[title]"
      assert_select "input#item_description", :name => "item[description]"
      assert_select "input#item_condition", :name => "item[condition]"
      assert_select "input#item_starting_price", :name => "item[starting_price]"
      assert_select "input#item_duration", :name => "item[duration]"
      assert_select "input#item_category_id", :name => "item[category_id]"
      assert_select "input#item_seller_id", :name => "item[seller_id]"
    end
  end
end

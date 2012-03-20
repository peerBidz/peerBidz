require 'spec_helper'

describe "searches/new.html.erb" do
  before(:each) do
    assign(:search, stub_model(Search,
      :keywords => "MyString",
      :category_id => 1,
      :minimum_price => 1.5,
      :maximum_price => 1.5,
      :seller_id => 1,
      :condition => false
    ).as_new_record)
  end

  it "renders new search form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => searches_path, :method => "post" do
      assert_select "input#search_keywords", :name => "search[keywords]"
      assert_select "input#search_category_id", :name => "search[category_id]"
      assert_select "input#search_minimum_price", :name => "search[minimum_price]"
      assert_select "input#search_maximum_price", :name => "search[maximum_price]"
      assert_select "input#search_seller_id", :name => "search[seller_id]"
      assert_select "input#search_condition", :name => "search[condition]"
    end
  end
end

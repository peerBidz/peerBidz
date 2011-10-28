require 'spec_helper'

describe "searches/index.html.erb" do
  before(:each) do
    assign(:searches, [
      stub_model(Search,
        :keywords => "Keywords",
        :category_id => 1,
        :minimum_price => 1.5,
        :maximum_price => 1.5,
        :seller_id => 1,
        :condition => false
      ),
      stub_model(Search,
        :keywords => "Keywords",
        :category_id => 1,
        :minimum_price => 1.5,
        :maximum_price => 1.5,
        :seller_id => 1,
        :condition => false
      )
    ])
  end

  it "renders a list of searches" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Keywords".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end

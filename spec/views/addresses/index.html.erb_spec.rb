require 'spec_helper'

describe "addresses/index" do
  before(:each) do
    assign(:addresses, [
      stub_model(Address,
        :full_name => "Full Name",
        :line_1 => "Line 1",
        :line_2 => "Line 2",
        :city => "City",
        :country => "Country",
        :postcode => 1,
        :phone_number => "Phone Number",
        :belongs_to => ""
      ),
      stub_model(Address,
        :full_name => "Full Name",
        :line_1 => "Line 1",
        :line_2 => "Line 2",
        :city => "City",
        :country => "Country",
        :postcode => 1,
        :phone_number => "Phone Number",
        :belongs_to => ""
      )
    ])
  end

  it "renders a list of addresses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Full Name".to_s, :count => 2
    assert_select "tr>td", :text => "Line 1".to_s, :count => 2
    assert_select "tr>td", :text => "Line 2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Phone Number".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end

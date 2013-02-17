require 'spec_helper'

describe "addresses/show" do
  before(:each) do
    @address = assign(:address, stub_model(Address,
      :full_name => "Full Name",
      :line_1 => "Line 1",
      :line_2 => "Line 2",
      :city => "City",
      :country => "Country",
      :postcode => 1,
      :phone_number => "Phone Number",
      :belongs_to => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Full Name/)
    rendered.should match(/Line 1/)
    rendered.should match(/Line 2/)
    rendered.should match(/City/)
    rendered.should match(/Country/)
    rendered.should match(/1/)
    rendered.should match(/Phone Number/)
    rendered.should match(//)
  end
end

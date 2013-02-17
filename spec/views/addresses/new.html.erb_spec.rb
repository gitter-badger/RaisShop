require 'spec_helper'

describe "addresses/new" do
  before(:each) do
    assign(:address, stub_model(Address,
      :full_name => "MyString",
      :line_1 => "MyString",
      :line_2 => "MyString",
      :city => "MyString",
      :country => "MyString",
      :postcode => 1,
      :phone_number => "MyString",
      :belongs_to => ""
    ).as_new_record)
  end

  it "renders new address form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => addresses_path, :method => "post" do
      assert_select "input#address_full_name", :name => "address[full_name]"
      assert_select "input#address_line_1", :name => "address[line_1]"
      assert_select "input#address_line_2", :name => "address[line_2]"
      assert_select "input#address_city", :name => "address[city]"
      assert_select "input#address_country", :name => "address[country]"
      assert_select "input#address_postcode", :name => "address[postcode]"
      assert_select "input#address_phone_number", :name => "address[phone_number]"
      assert_select "input#address_belongs_to", :name => "address[belongs_to]"
    end
  end
end

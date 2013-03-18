require 'spec_helper'

describe Address do

  let!(:address) { create(:address) }
  subject { address }

  it { should be_valid }

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:orders) }
    it { should accept_nested_attributes_for(:user) }
    it { should have_db_index(:user_id) }
  end

  describe "validators" do
    describe "presence of validations" do
      [:city, :country, :line_1, :phone_number, :postcode].each do |attr|
        it { should validate_presence_of(attr) }
      end
    end

    it { should allow_mass_assignment_of(:user) }

    it { should allow_value('12345').for(:postcode) }
    it { should_not allow_value('1234').for(:postcode) }
    it { should_not allow_value('123456').for(:postcode) }
  end

  describe "instance methods" do
    it "returns address info in html" do
      info = "#{address.line_1}<br/>#{address.line_2}<br/>#{address.country}<br/>" +
        "#{address.city}<br/>#{address.postcode}<br/>#{address.phone_number}"
      expect(address.info_in_html).to eq(info)
    end
  end
end

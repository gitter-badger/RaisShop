require 'spec_helper'

describe LineItem do

  let(:line_item) { create(:line_item) }

  subject { line_item }

  it { should be_valid }

  describe "quantity sets to 1 after creation by default" do
    subject { LineItem.new }

    its(:quantity) { should == 1 }
  end

  describe "quantity should be can't be less than 0" do
    before { line_item.quantity = 0 }

    it { should_not be_valid }
  end

  describe "#total_price" do
    before do
      line_item.product.price = 40.33
      line_item.quantity = 3
    end

    its(:total_price) { should eq BigDecimal("120.99") }
  end
end

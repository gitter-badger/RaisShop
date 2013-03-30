require 'spec_helper'

describe Cart do

  let(:product) { create(:product, price: 25) }
  let(:cart) { create(:cart) }
  let(:cart_with_items) { build(:cart_with_items) }

  subject { cart }

  it { should be_valid }

  describe '#empty?' do
    context 'with items' do
      subject { cart_with_items }

      it { should_not be_empty }
      it { should have(10).line_items }
    end

    it { should be_empty }
    it { should have(0).line_items }
  end

  describe "#count" do
    it "adding an item" do
      expect { cart.add_product(product.id) }.to change{ cart.count }.by(1)
    end

    it "adding the same item many times" do
      expect {
        3.times do
          cart.add_product(product.id)
        end
      }.to change{ cart.count }.by(3)
    end

    its(:count) { should == 0 }
  end

  describe "#total_price" do

    it "calculates total price of cart items" do
      3.times do
        cart.add_product(product.id)
      end

      expect(cart.total_price).to eq(BigDecimal(75))
    end
    its(:total_price) { should == 0 }
  end

  describe "#add_product" do

    it "increments count after adding an item" do
      expect {
        cart.add_product(product.id)
      }.to change{ cart.count }.by(1)
    end

    it "increments count after adding the same item" do
      cart.add_product(product.id)
      expect {
        cart.add_product(product.id)
      }.to change{ cart.count }.by(1)
    end

    it "increments line_item quantity after adding the same item" do
      cart.add_product(product.id)
      expect {
        cart.add_product(product.id)
      }.to change{ cart.line_items.first.quantity }.by(1)
    end
  end
end

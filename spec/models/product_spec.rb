require 'spec_helper'

describe Product do

  let(:product) { build(:product) }
  let(:user) { build(:user) }
  let(:admin) { build(:admin) }

  subject { product }

  it { should be_valid }

  describe "creates human-readable slug" do
    before do
      product.title = "Best PC evar 12 edition"
      product.save
    end

    its(:to_param) { should =~ /best-pc-evar-12-edition/ }
  end

  describe "destroying a product" do
    context "when it doesn't exist in any cart" do

      before { product.destroy }

      it { should be_destroyed }
    end

    context "when it exist in some cart" do

      before do
        product.line_items << build(:line_item)
        product.destroy
      end

      it { should_not be_destroyed }

      it "adds errors to base" do
        expect(product.errors.full_messages).to include 'Line Items Present'
      end
    end
  end

  describe "calculates average rating for product" do
    before do
      reviews = build_list(:review, 10)
      product.reviews << reviews
      reviews.map(&:save)
      product.rating = 100
      product.save!
    end

    its(:rating) { should == 3 }
  end

  describe "sets rating to zero for product without reviews" do
    before do
      product.rating = 1
      product.reviews = []
      product.save!
    end

    its(:rating) { should == 0 }
  end


  describe "sets rating to zero for product without reviews" do
    before do
      product.reviews = []
      product.save
      product.reviews << [build(:review, rating: 5)]
      product.reviews.map(&:save)
      product.save
    end

    it "works" do
      product.rating.should == 5
      product.reviews.first.destroy
      product.rating.should == 0
    end
  end
end

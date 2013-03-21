require 'spec_helper'

describe Review do

  let(:review) { build(:review, rating: 5, product: nil) }
  let(:product) { build(:product) }
  let(:user) { build(:user) }

  subject { review }

  describe "validators" do
    describe "presence of validations" do
      [:comment, :rating, :user, :product_id].each do |attr|
        it { should validate_presence_of(attr) }
      end
    end
  end

  describe "calculates rating for product after saving a review" do
    subject { product }
    before do
      product.save
      product.reviews << review
      puts review.persisted?
      review.save
    end

    its(:rating) { should == 5 }
  end

  describe "calculates average rating for product" do
    subject { product }
    before do
      product.save
      reviews = build_list(:review, 100)
      product.reviews << reviews
      reviews.map(&:save)
    end

    its(:rating) { should == 3 }
  end
end

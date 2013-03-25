require 'spec_helper'

describe Review do

  let(:review) { build(:review, rating: 5) }
  let(:product) { build(:product) }
  let(:user) { build(:user) }

  subject { review }

  describe "validators" do
    describe "presence of validations" do
      [:comment, :rating, :user, :product_id].each do |attr|
        it { should validate_presence_of(attr) }
      end
    end

    it "does not allow rating less than 0" do
      rating = -1
      should_not be_valid
    end

    it "does not allow rating greater than 5" do
      rating = 6
      should_not be_valid
    end

    describe "only one review from user per product" do
      before do
        user.save
        user.reviews.create({comment: 'sdf', rating: 5, product_id: product.id})
        review.product = product
        review.user = user
      end

      it { should_not be_valid }
    end
  end

  describe "calculates rating for product after saving a review" do
    subject { product }
    before do
      product.save
      product.reviews << review
      review.save
    end

    its(:rating) { should == 5 }
  end
end
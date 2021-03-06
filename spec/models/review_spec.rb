require 'spec_helper'

describe Review do

  let(:review) { build(:review, rating: 5) }
  let(:product) { build(:product) }
  let(:user) { build(:user) }

  subject { review }

  describe "validators" do
    describe "presence of validations" do
      [:comment, :user, :product_id].each do |attr|
        it { should validate_presence_of(attr) }
      end
    end

    describe "does not allow rating less than 1" do
      before { review.rating = 0 }
      it { should_not be_valid }
    end

    describe "does not allow rating greater than 5" do
      before { review.rating = 6 }
      it { should_not be_valid }
    end

    describe "only one review from user per product" do
      before do
        user.save!
        product.save!
        user.reviews.create({comment: 'sdf', rating: 5, product_id: product.id})
        review.product_id = product.id
        review.user = user
      end

      it { should_not be_valid }
      it { should have(1).errors_on(:base) }
    end
  end

  describe "calculates rating for product after saving a review" do
    subject { product }
    before do
      product.save
      product.reviews << review
      review.save!
    end

    its(:rating) { should == 5 }
  end
end

require 'spec_helper'
require 'shared_stuff'

describe "Product pages" do

  subject { page }

  let (:user) { create(:user) }
  let (:product) { create(:product) }
  let (:admin) { create(:admin) }

  context "user signed out" do
    before { visit product_path(product) }

    it { should_not have_review_form }
  end

  context "user signed in" do
    before do
      sign_in user
      visit product_path(product)
    end

    it { should have_review_form }

    describe "review creation" do
      context "with valid information" do
        before do
          choose("review_rating_3")
          fill_in "review_comment", with: "Good one."
        end

        it "creates a review" do
          expect {
            click_button("Create Review")
          }.to change{ product.reviews.count }.by(1)
        end

        it "doesn't allow a review for a product more than once" do
          click_button("Create Review")
          should_not have_review_form
        end

        it "calculates average product rating" do
          click_button("Create Review")
          should have_selector("#rating", text: '3')
        end
      end

      context "with invalid information" do
        it " doesn't create a review" do
          expect {
            click_button("Create Review")
          }.to change{ product.reviews.count }.by(0)
        end
      end
    end

    describe "review deletion" do
      before do
        choose("review_rating_3")
        fill_in "review_comment", with: "Good one."
        click_button("Create Review")
      end

      it "has only one 'destroy review' link" do
        expect(all('a', text: "Destroy review").size).to eq(1)
      end

      it "deletes a review" do
        expect {
          click_link("Destroy review")
        }.to change{ product.reviews.count }.by(-1)
        should_not have_link("Destroy review")
      end

      it "recalculates average rating" do
        click_link("Destroy review")
        should have_selector("#rating", text: '0')
      end
    end
  end

  context "admin logged in" do
    include_context "sign in as admin"
    before do
      reviews = create_list(:review, 4)
      product.reviews << reviews
      reviews.map(&:save)
      visit product_path(product)
    end

    it "allows destroy any review" do
      expect(all('a', text: "Destroy review").size).to eq(4)
    end
  end

  def have_review_form
    have_selector('form#new_review')
  end
end

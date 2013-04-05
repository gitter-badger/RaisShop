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
          xpath = "//div[@class='productRating']/div[@style='background-position: -27px 0;']"
          should have_xpath(xpath)
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
        xpath = "//div[@class='productRating']/div[@style='background-position: -66px 0;']"
        should have_xpath(xpath)
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

  context "products view customization" do
    before do
      create_list(:product, 20)
      visit products_path
    end

    describe "choosing per page products count" do
      before do
        page.select('20', from: 'per_page')
        click_button 'Filter'
      end
      it { should have_selector('table .product', count: 20) }
    end

    describe "10 products per page by default" do
      it { should have_selector('table .product', count: 10) }
    end

    describe "endless pagination", js: true do
      before do
        page.select('10', from: 'per_page')
        check('endless_page')
        click_button 'Filter'
        page.execute_script "window.scrollBy(0,10000)"
        #find_by_id('footer').click
      end

      it { should have_selector('table .product', count: 20) }
    end
  end
end

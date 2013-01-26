require 'spec_helper'

describe ReviewsController do

  let (:user) { create(:user) }
  let (:product) { create(:product) }

  it "shouldn't render review form for unsigned user" do
    visit product_path(product)
    page.should_not have_selector("legend", text: "Please rate:")
  end

  it "allows to write one review for signed in user"do
    sign_in user
    visit product_path(product)
    page.should have_selector("legend", text: "Please rate:")
    choose("review_rating_3")
    fill_in "review_comment", with: "Good one."
    expect {
      click_button("Create Review")
    }.to change{ product.reviews.count }.by(1)
    page.should_not have_selector("legend", text: "Please rate:")
  end
end

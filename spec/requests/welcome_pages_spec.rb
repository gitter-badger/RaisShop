require 'spec_helper'

describe "WelcomePages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    #it { should have_selector('title', text: full_title('')) }

    it "should have a list of recently viewed items" do
      product = create(:product)
      visit product_path(product)
      visit root_path
      history = [product]
      page.should have_selector('#recent_history tr td',product.title)
      product2 = create(:product)
      visit product_path(product2)
      visit root_path
      history << product2
      page.should have_selector('#recent_history tr td',product2.title)
      #subject.should have_selector('table tr td', text: product.title)
    end
    context "when user is signed-in" do
      let(:user) { create(:user) }
      before { sign_in user }
    end
  end
end

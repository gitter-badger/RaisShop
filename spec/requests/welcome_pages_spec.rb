require 'spec_helper'

describe "WelcomePages" do

  subject { page }

  describe "Home page" do
    before { visit root_path }

    #it { should have_selector('title', text: full_title('')) }

    describe "Recent history" do 

      def visit_product(product)
        visit product_path(product)
        visit root_path
      end

      let(:products) { create_list(:product, 5) }

      before(:each) do
        products.each {|prod| visit_product(prod) }
      end

      it "should contain product after visiting it" do
        products.each do |prod|
          page.should have_selector('#recent_history tr td', prod.title)
        end
      end

      it "should contain only last visited instance of the same product" do
        visit_product(products.first)
        all_history = page.all(:css, "#recent_history tr td")
        all_history.first.text.should == products.first.title
        all_history.last.text.should  == products[1].title
      end
    end
  end
end

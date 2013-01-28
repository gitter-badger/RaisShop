require 'spec_helper'

describe CartCell do

  context "cell instance" do
    subject { cell(:cart) }

    it { should respond_to(:show) }
  end

  context "cell rendering" do
    context "rendering show" do
      subject { render_cell(:cart, :show) }

      it { should have_selector("h1", :text => "Cart#show") }
      it { should have_selector("p", :text => "Find me in app/cells/cart/show.html") }
    end
  end

end

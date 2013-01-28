require 'spec_helper'

describe NavbarCell do

  context "cell instance" do
    subject { cell(:navbar) }

    it { should respond_to(:show) }
  end

  context "cell rendering" do
    context "rendering show" do
      subject { render_cell(:navbar, :show) }

      it { should have_selector("h1", :text => "Navbar#show") }
      it { should have_selector("p", :text => "Find me in app/cells/navbar/show.html") }
    end
  end

end

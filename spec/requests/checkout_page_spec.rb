require 'spec_helper'

describe "Checkout page" do

  shared_examples_for "it creates an order" do
    include_context "fills order related inputs"
    it "creates an order" do
      Order.count.should == 1
      Customer.count.should == 1
      Address.count.should == 1
      expect(current_path).to eq root_path
    end
  end

  shared_examples_for "it doesn't create an order" do
    it "doesn't create and order" do
      Order.count.should == 0
      should have_content("Please review the problems below")
      should_not have_content("Your order is accepted and being processed")
      expect(current_path).not_to eq root_path
    end
  end

  shared_examples_for "it doesn't create a user and an address" do
    it "it doesn't create a user and an address" do
      Customer.count.should == 0
      Address.count.should == 0
    end
  end

  shared_context "fills in all but one required address fields" do
    before do
      fill_in "City", with: "some_address"
      fill_in "Postcode", with: "12345"
      select "Aruba", from: "Country"
      fill_in "Phone number", with: "some_address"
    end
  end

  shared_context "fills order related inputs" do
    before do
      select "Check", from: "Pay type"
      select "Express", from: "Shipping type"
    end
  end

  subject { page }

  before do
    cart = create(:cart_with_items)
    page.set_rack_session(cart_id: cart.id)
    visit new_order_path
  end

  context "Signed in user" do
    let(:user) { create(:user_with_address) }
    before { sign_in user }

    it_behaves_like "it creates an order" do
      before do
        choose("order_address_id_#{user.addresses.first.id}")
        click_button("Confirm order")
      end
    end

    it_behaves_like "it doesn't create an order" do
      before { click_button("Confirm order") }
    end
  end

  context "Signed in user without any address" do
    let(:user) { create(:user) }
    before { sign_in user }

    it_behaves_like "it creates an order" do
      include_context "fills in all but one required address fields"
      before do
        fill_in "Address line 1", with: "some_address"
        click_button("Confirm order")
      end
    end

    it_behaves_like "it doesn't create an order" do
      include_context "fills in all but one required address fields"
      before { click_button("Confirm order") }
      specify { Address.count.should == 0 }
    end
  end

  describe "guest user" do
    it_behaves_like "it creates an order" do
      include_context "fills in all but one required address fields"
      before do
        fill_in "Full name", with: "loh"
        fill_in "Address line 1", with: "some_address"
        click_button("Confirm order")
      end
    end

    shared_examples_for "guest user doesn't create order" do
      include_context "fills in all but one required address fields"
      it_behaves_like "it doesn't create an order" do
        it_behaves_like "it doesn't create a user and an address"
      end
    end

    it_behaves_like "guest user doesn't create order" do
      before do
        fill_in "Address line 1", with: "some_address"
        click_button("Confirm order")
      end
    end

    it_behaves_like "guest user doesn't create order" do
      before do
        fill_in "Full name", with: "loh"
        click_button("Confirm order")
      end
    end

    it_behaves_like "guest user doesn't create order" do
      before do
        fill_in "Full name", with: "loh"
        fill_in "Address line 1", with: "some_address"
        click_button("Confirm order")
      end
    end
  end
end

require 'spec_helper'

describe "Checkout page" do

  shared_examples_for "it creates an order" do
    it { should_not have_content("Please review the problems below") }
    it { should have_content("Your order is accepted and being processed") }
    specify { Order.count.should == 1 }
    its(:current_url){ should eq root_url }
  end

  shared_examples_for "it doesn't create an order" do
    it { should have_content("Please review the problems below") }
    it { should_not have_content("Your order is accepted and being processed") }
    specify { Order.count.should == 0 }
  end

  shared_context "fills in all but one required address fields" do
    before do
      fill_in "City", with: "some_address"
      fill_in "Postcode", with: "12345"
      select "Aruba", from: "Country"
      fill_in "Phone number", with: "some_address"
    end
  end

  let(:user) { create(:user) }

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

    it { should_not have_selector("fieldset#user_fields") }
  end

  context "Signed in user without any address" do
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
    end

    it { should_not have_selector("fieldset#user_fields") }
    it { should have_selector("fieldset#address_fields") }
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

    it_behaves_like "it doesn't create an order" do
      include_context "fills in all but one required address fields"
      before do
        fill_in "Address line 1", with: "some_address"
        click_button("Confirm order")
      end
    end

    it { should have_selector("fieldset#user_fields") }
    it { should have_selector("fieldset#address_fields") }
  end
end

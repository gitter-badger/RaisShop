require 'spec_helper'

describe AddressesController do

  let(:user) { create(:user_with_address) }
  #let(:address) { create(:address) }
  let(:address) { user.addresses.first }

  describe "GET index" do
    it "assigns current signed in user addresses" do
      sign_in user
      get :index
      assigns(:addresses).should eq([address])
    end

    it "redirects to login page" do
      get :index
      response.should redirect_to new_user_session_path
    end
  end

  describe "GET new" do
    it "assigns a new address as @address" do
      sign_in user
      get :new
      assigns(:address).should be_a_new(Address)
    end

    it "redirect to login page" do
      get :new
      response.should redirect_to new_user_session_path
    end
  end

  describe "GET edit" do

    it "assigns the requested address as @address" do
      sign_in user
      get :edit, {:id => address.to_param}
      assigns(:address).should eq(address)
    end

    it "redirects to log in page" do
      get :edit, {:id => address.to_param}
      response.should redirect_to new_user_session_path
    end

    context "when user tries to access disowned address" do

      let(:user2) { create(:user_with_address) }

      before(:each) do
        sign_in user2
      end

      it "redirects to #index" do
        get :edit, {:id => address.to_param}
        response.should redirect_to(addresses_path)
      end

      it "sets flash message" do
        get :edit, {id: address.to_param}
        flash[:notice].should eq("You can access only your own address")
      end
    end
  end

  describe "POST create" do

    before(:each) do
      sign_in user
    end

    describe "with valid params" do

      let(:valid_address_attributes) { { address: attributes_for(:address) } }

      it "creates a new Address" do
        expect {
          post :create, valid_address_attributes
        }.to change(Address, :count).by(1)
      end

      it "assigns a newly created address as @address" do
        post :create, valid_address_attributes
        response.should redirect_to(addresses_path)
        assigns(:address).should be_a(Address)
        assigns(:address).should be_persisted
      end

      it "redirects to user addresses" do
        post :create, valid_address_attributes
        response.should redirect_to(addresses_path)
      end
    end

    describe "with invalid params" do

      let(:invalid_address) { {  address: {city: "Ternopil"} } }

      it "assigns a newly created but unsaved address as @address" do
        Address.any_instance.stub(:save).and_return(false)
        post :create, invalid_address
        assigns(:address).should be_a_new(Address)
      end

      it "re-renders the 'new' template" do
        Address.any_instance.stub(:save).and_return(false)
        post :create, invalid_address
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      sign_in user
    end

    describe "with valid params" do

      let(:valid_address_attributes) { attributes_for(:address) }

      it "updates the requested address" do
        city = { "city" => "Moscow" }
        Address.any_instance.should_receive(:update_attributes).with(city)
        put :update, {:id => address.to_param, :address => city}
      end

      it "assigns the requested address as @address" do
        put :update, {id:  address.to_param, address: valid_address_attributes }
        assigns(:address).should eq(address)
      end

      it "redirects to the address" do
        put :update, {id: address.to_param, address: valid_address_attributes }
        response.should redirect_to(addresses_path)
      end
    end

    describe "with invalid params" do

      let(:invalid_postcode) { { postcode: 123 } }

      it "assigns the address as @address" do
        put :update, {:id => address.to_param, :address => invalid_postcode }
        assigns(:address).should eq(address)
      end

      it "re-renders the 'edit' template" do
        Address.any_instance.stub(:save).and_return(false)
        put :update, {:id => address.to_param, :address => invalid_postcode }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before { sign_in user }
    it "destroys the requested address" do
      expect {
        delete :destroy, {:id => address.to_param}
      }.to change(Address, :count).by(-1)
    end

    it "redirects to the addresses list" do
      delete :destroy, {:id => address.to_param}
      response.should redirect_to(addresses_path)
    end
  end
end

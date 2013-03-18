require 'spec_helper'

describe OrdersController do

  let(:order) { create(:order_with_user) }
  let(:address) { order.address }
  let(:user) { address.user }
  let(:cart) { create(:cart) }
  let(:admin) { create(:admin) }

  describe "GET index" do
    it "assigns all current user orders" do
      sign_in user
      get :index
      assigns(:orders).should eq([order])
    end

    it "redirects to login page for logged out user" do
      get :index
      response.should redirect_to new_user_session_path
    end
  end

  describe "GET new" do
    context "when cart is not empty" do
      before { session[:cart_id] = cart.id }
      it "assigns a new order as @order" do
        get :new
        assigns(:order).should be_a_new(Order)
      end

      it "assigns a new address and user" do
        get :new
        assigns(:address).should be_a_new(Address)
        assigns(:address).should == assigns(:order).address
        assigns(:user).should be_a_new(User)
        assigns(:user).should == assigns(:address).user
      end

      context "when user logged in" do
        before { sign_in user }
        it "doesn't assign a new address and user" do
          get :new
          assigns(:address).should be_nil
          assigns(:user).should be_nil
        end
      end
    end

    context "when cart is empty" do
      it "redirects to root_path" do
        get :new
        response.should redirect_to root_path
      end

      it "sets flash message" do
        get :new
        flash[:notice].should == "Your cart is empty"
      end
    end
  end

  describe "GET edit" do
    context "admin logged in" do
      before { sign_in admin }
      it "assigns the requested order" do
        get :edit, {:id => order.to_param}
        assigns(:order).should eq(order)
      end
    end
      it "redirect to root path" do
        get :edit, {:id => order.to_param}
        response.should redirect_to root_path
      end
  end

  describe "POST create" do
    describe "with valid params" do

      before(:each) do
        @valid_attributes = attributes_for(:order)
        @valid_attributes[:address_attributes] = attributes_for(:address)
        @valid_attributes[:address_attributes][:user_attributes] = attributes_for(:user)
        session[:cart_id] = cart.id
      end

      it "creates a new Order" do
        expect {
          post :create, {order: @valid_attributes}
        }.to change(Order, :count).by(1)
      end

      it "assigns a newly created order as @order" do
        post :create, {order: @valid_attributes}
        assigns(:order).should be_a(Order)
        assigns(:order).should be_persisted
      end

      it "redirects to the created order" do
        post :create, {order: @valid_attributes}
        response.should redirect_to root_path
      end

      it "adds line items from the cart" do
        Order.any_instance.should_receive(:add_line_items_from_cart)
          .with(cart)
        post :create, {order: @valid_attributes}
      end

      it "destroys cart" do
        expect {
          post :create, {order: @valid_attributes}
        }.to change(Cart, :count).by(-1)
        session[:cart_id].should be_nil
        Cart.find_by_id(cart.id).should be_nil
      end
    end

    describe "with invalid params" do

      let(:invalid_order) { { order: { shipping_type: "non-existing-type" } } }

      it "assigns a newly created but unsaved order as @order" do
        post :create, invalid_order
        assigns(:order).should be_a_new(Order)
      end

      it "re-renders the 'new' template" do
        post :create, invalid_order
        response.should render_template("new")
      end

      it "does not save an order" do
        Order.any_instance.should_receive(:save).and_return(false)
        post :create, invalid_order
        assigns(:order).should_not be_persisted
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      @valid_attributes = attributes_for(:order)
      @valid_attributes[:address_attributes] = attributes_for(:address)
      @valid_attributes[:address_attributes][:user_attributes] = attributes_for(:user)
    end

    context "admin logged in" do
      before { sign_in admin }
      describe "with valid params" do

        it "updates the requested order" do
          payment_type = { "pay_type" => "Credit cart" }
          Order.any_instance.should_receive(:update_attributes).with(payment_type)
          put :update, {id: order.id, order: payment_type}
        end

        it "assigns the requested order as @order" do
          put :update, {id: order.id, order: @valid_attributes}
          assigns(:order).should eq(order)
        end

        it "redirects to the order" do
          put :update, {id: order.id, order: @valid_attributes}
          response.should redirect_to root_path
        end
      end

      describe "with invalid params" do

        let(:invalid_params) { { shipping_type: "non-existing-type" } }

        it "assigns the order as @order" do
          Order.any_instance.stub(:save).and_return(false)
          put :update, {id: order.id, order: invalid_params}
          assigns(:order).should eq(order)
        end

        it "re-renders the 'edit' template" do
          Order.any_instance.stub(:save).and_return(false)
          put :update, {id: order.id, order: invalid_params}
          response.should render_template("edit")
        end
      end
    end

    it "redirects to root path for non-admin user" do
      put :update, {id: order.id, order: @valid_attributes}
      response.should redirect_to root_path
    end
  end

  describe "DELETE destroy" do
    context "admin logged in" do
      before { sign_in admin }

      it "destroys the requested order" do
        order = create(:order)
        expect {
          delete :destroy, {id: order.id}
        }.to change(Order, :count).by(-1)
      end

      it "redirects to the orders list" do
        delete :destroy, {id: order.to_param}
        response.should redirect_to(orders_url)
      end
    end
  end
end

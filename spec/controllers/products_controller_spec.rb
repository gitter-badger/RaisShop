require 'spec_helper'
require 'shared_stuff'

describe ProductsController do

  let(:admin) { create(:admin) }
  let!(:product) { create(:product) }

  describe 'GET #index' do
    it 'assigns products' do
      get :index
      expect(assigns(:products)).to match_array([product])
    end

    it 'responses with json array of titles' do
      get :index, format: :json
      expect(response.header['Content-Type']).to include 'application/json'
      expect(response.body).to eq([product.title].to_json)
    end

    it 'responses to js' do
      get :index, format: :js
      expect(response.header['Content-Type']).to include 'text/javascript'
      expect(response.status).to eq(200)
    end
  end

  describe 'GET #show' do
    it 'assigns product' do
      get :show, id: product.id
      expect(assigns(:product)).to eq(product)
    end

    describe 'recent history for this session' do
      it 'adds product id' do
        get :show, id: product.id
        expect(session[:recent_history][product.id]).not_to be_nil
      end

      it 'maps product id to current time' do
        get :show, id: product.id
        expect(session[:recent_history][product.id]).to be_within(5.seconds).of(Time.now)
      end
    end
  end

  describe 'GET new' do
    context 'when admin logged in' do
      include_context "sign in as admin"

      it 'assigns new product' do
        get :new
        expect(assigns(:product)).to be_a_new(Product)
      end
    end

    it 'redirects to root_path' do
      get :new
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET edit' do
    context 'when admin logged in' do
      include_context "sign in as admin"

      it 'assigns product' do
        get :edit, id: product.id
        expect(assigns(:product)).to eq(product)
      end
    end

    it 'redirects to root_path' do
      get :edit, id: product.id
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    context 'when admin logged in' do
      include_context "sign in as admin"

      describe "with valid params" do

        let(:valid_product) { { product: attributes_for(:product) } }

        it "creates a new Product" do
          expect {
            post :create, valid_product
          }.to change(Product, :count).by(1)
        end

        it "assigns a newly created product" do
          post :create, valid_product
          expect(assigns(:product)).to be_a(Product)
          expect(assigns(:product)).to be_persisted
        end

        it "redirects to the product" do
          post :create, valid_product
          response.should redirect_to(product_path(assigns(:product)))
        end

        it "sets flash notice" do
          post :create, valid_product
          expect(flash[:notice]).to eq("Product was successfully created.")
        end
      end

      describe "with invalid params" do

        let(:invalid_product) { {  product: {description: "Ternopil"} } }

        it "assigns a newly created but unsaved product" do
          post :create, invalid_product
          assigns(:product).should be_a_new(Product)
        end

        it "re-renders the 'new' template" do
          post :create, invalid_product
          response.should render_template("new")
        end
      end
    end

    it 'redirects to root_path' do
      post :create, id: product.id
      expect(response).to redirect_to root_path
    end
  end

  describe "PUT update" do
    context 'when admin logged in' do
      include_context "sign in as admin"

      describe "with valid params" do

        let(:valid_product_attributes) { attributes_for(:product) }

        it "updates the requested product" do
          description = { "description" => "Teh best product evar!" }
          Product.any_instance.should_receive(:update).with(description)
          put :update, { id: product.id, product: description}
        end

        it "assigns the requested product" do
          put :update, { id:  product.id, product: valid_product_attributes }
          assigns(:product).should eq(product)
        end

        it "redirects to the product" do
          put :update, { id: product.id, product: valid_product_attributes }
          response.should redirect_to(product_path(assigns(:product)))
        end

        it "sets flash notice" do
          put :update, { id: product.id, product: valid_product_attributes }
          expect(flash[:notice]).to eq("Product was successfully updated.")
        end
      end

      describe "with invalid params" do

        let(:invalid_title) { { title: '' } }

        it "assigns the product" do
          put :update, { id: product.id, product: invalid_title }
          assigns(:product).should eq(product)
        end

        it "re-renders the 'edit' template" do
          put :update, { id: product.id, product: invalid_title }
          response.should render_template("edit")
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when admin logged in' do
      include_context "sign in as admin"

      it "destroys the requested product" do
        expect {
          delete :destroy, id: product.id
       }.to change(Product, :count).by(-1)
      end

      it "redirects to admin page" do
        delete :destroy, id: product.id
        expect(response).to redirect_to admin_path
      end
    end

    it 'redirects to root_path' do
      delete :destroy, id: product.id
      expect(response).to redirect_to root_path
    end
  end
end

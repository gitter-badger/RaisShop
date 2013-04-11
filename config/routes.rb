RaisShop::Application.routes.draw do

  root to: "shop#index"

  match "admin" => "shop#admin"
  match "search" => "shop#search"
  match "query_freq" => "freq#get"

  resources :addresses, except: [:show, :index]
  resources :orders
  resources :categories
  resources :line_items, except: [:index, :show, :edit, :new]
  resources :carts, except: [:index, :edit, :new]

  devise_for :users, path_names: {sign_in: "login"},
    controllers: { sessions: "sessions", registrations: "registrations"}

  resources :products, only: [:index, :new, :create]
  resources :products, path: "", except: [:index, :new, :create] do
    resources :reviews, only: [:create, :destroy]
  end
end

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "pages#home"

  get "search", to: "pages#search"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :vans, only: %i[index show new create] do
    resources :reviews, only: %i[index]
    get "tracking" => "vans#tracking", as: :tracking
    get "orders" => "vans#orders", as: :orders
    get "products/:id" => "products#show", as: :product
    patch "products/:id" => "products#update"
    resources :orders, only: %i[show create update destroy]
    resources :inventories
  end

  get "cart", to: "order_products#show", as: :cart
  post "cart/add/:product_id", to: "order_products#create", as: :add_to_cart
  delete "cart/remove/:id", to: "order_products#destroy", as: :remove_from_cart
  delete "cart/clear", to: "order_products#clear", as: :clear_cart

  resources :orders, only: %i[index show new create] do
    resources :reviews, only: %i[index new create show]
    get "checkout", to: "orders#checkout", as: :checkout
  end

  resources :favourites, only: %i[index destroy create]
end

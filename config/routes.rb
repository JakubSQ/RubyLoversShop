Rails.application.routes.draw do
  root to: "pages#home"
  patch 'orders/remove_address', to: 'orders#remove_address', as: 'remove_address'
  get 'orders/set_address', to: 'orders#set_address', as: 'set_address'
  resources :orders, only: [:new, :create, :destroy]
  resources :products, only: [:index, :show]
  resources :line_items, only: [:create, :destroy, :update]
  resources :carts, only: [:show, :create, :destroy]
  devise_for :admins
  devise_for :users, controllers: { sessions: 'users/sessions' } do
    member do 
      patch :remove_address
    end
  end

  namespace :admin do
    root to: "products#dashboard"
    resources :products, except: :show
    resources :orders, only: [:index, :show, :edit] do
      member do
        patch :order_status
        patch :payment_status
        patch :shipment_status
      end
    end
  end 
end

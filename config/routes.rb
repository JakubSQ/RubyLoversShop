Rails.application.routes.draw do
  root to: "pages#home"
  get 'orders/set_address', to: 'orders#set_address', as: 'set_address'
  resources :orders, only: [:new, :create, :destroy]
  resources :products, only: [:index, :show]
  resources :line_items, only: [:create, :destroy, :update]
  resources :carts, only: [:show, :create, :destroy]
  devise_for :admins
  devise_for :users, controllers: { sessions: 'users/sessions' }

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

Rails.application.routes.draw do
  root to: "pages#home"
  resources :orders
  resources :products
  resources :line_items
  resources :carts
  devise_for :admins
  devise_for :users, controllers: { sessions: 'users/sessions' }

  namespace :admin do
    root to: "products#dashboard"
    resources :products
  end 
end

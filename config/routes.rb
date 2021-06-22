Rails.application.routes.draw do
  devise_for :admins
  devise_for :users

  namespace :admin do
    root to: "products#dashboard"
    resources :products
  end

  resources :products
  root to: "pages#home"
end

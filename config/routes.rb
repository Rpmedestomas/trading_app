Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get 'home/index'
  devise_for :users
  resources :users
  resources :stocks
  # root 'home#index'
  root 'stocks#index'
  
  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

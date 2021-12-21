Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  resources :stocks
  # root 'home#index'
  root 'stocks#index'

  post 'search' => 'stocks#search', as: :search
  
  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

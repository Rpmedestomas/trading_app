Rails.application.routes.draw do
  root 'home#index'
  devise_for :users
  # resources :users, only: [:index, :show, :edit, :update]

  resources :stocks
  
  resources :admin

  post 'search' => 'stocks#search', as: :search
  post 'add_stock' => 'stocks#add_stock', as: :add_stock
  post 'sell_stock' => 'stocks#sell_stock', as: :sell_stock
  post 'create_user' => 'admin#create', as: :create_user
  
  get 'home/index'
  get 'buy_stock/:symbol' => 'stocks#buy_stock', as: :buy_stock
  get 'out_stock/:symbol' => 'stocks#out_stock', as: :out_stock
 
  get 'portfolio' => 'user#portfolio', as: :portfolio

  # get '/users/sign_out' => 'user#sign_out', as: :sign_out
  
  get 'approve_user/:id' => 'admin#approve_user', as: :approve_user
  get 'approve_status/:id' => 'admin#approve_status', as: :approve_status
  get 'reject_user/:id' => 'admin#reject_user', as: :reject_user
  get 'reject_status/:id' => 'admin#reject_status', as: :reject_status
  # get 'admin/index' => 'admin#index', as: :admin_index

  patch 'admin/:id/edit' => 'admin#update', as: :update_user
  
  
  # devise_scope :user do
  #   root to: "devise/sessions#new"
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

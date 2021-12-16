Rails.application.routes.draw do
  devise_for :users
  resources :users
  resources :stocks
  root 'users_devise_sessions_new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

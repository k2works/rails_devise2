Devise2::Application.routes.draw do
  get "users/index"

  get "users/show"

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
end

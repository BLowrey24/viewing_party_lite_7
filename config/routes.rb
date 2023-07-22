Rails.application.routes.draw do
  root "welcome#index"
  get "/dashboard", to: "users#dashboard"
  get "/register", to: "users#new"

  resources :users, only: [:create] do
    resources :discover, only: [:index]
    resources :movies, only: [:index, :show] do
      resources :viewing_parties, only: [:new, :create]
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
end

# get "/login", to: "users#login_form"
# post "/login", to: "users#login_user"
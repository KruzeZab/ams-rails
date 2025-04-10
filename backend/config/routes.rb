Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [ :create, :index, :show, :update, :destroy ]

      post 'register', to: 'registrations#create'

      post "login", to: "sessions#create"
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

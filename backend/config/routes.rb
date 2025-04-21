Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index, :show, :update, :destroy] do
        collection do
          get 'check-email', to: 'users#check_email'
        end
      end

      resources :artists, only: [:index, :show] do
        collection do
          post :upload
          get :download
        end
      end

      resources :musics, only: [:index, :create, :show, :update, :destroy]

      resources :activity_logs, only: [:index], path: "activity-logs"

      post 'register', to: 'users#create_super_admin'

      post "login", to: "sessions#create"
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

Rails.application.routes.draw do
  #api definition
  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :tokens, only: [:create]
      resources :products
      resources :orders, only: [:index,:show, :create]
      resources :reports, only: [:index, :show] do
        collection do
          get :real_time_data
        end
        member do
          get :real_hour_data
        end
      end
      resources :games, only: [:index]
    end
  end
end

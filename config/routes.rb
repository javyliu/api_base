Rails.application.routes.draw do
  #api definition
  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :users, only: [:show, :create, :update, :destroy]
      resources :tokens, only: [:create]
      resources :products
      resources :orders, only: [:index,:show, :create]
      resources :reports, only: [:index] do
        collection do
          get :real_time_data
          get :accounts_gt_money
        end
      end
      resources :games, only: [:index, :show]  do
        member do
          get :time_data
          get :summary
        end
      end


    end
  end
end

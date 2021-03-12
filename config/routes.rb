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
          get :channel_users
          get :synthetic_data
          get :new_account_behavior
          get :retention_rate
          get :participation
          get :online_time
          get :max_level
          get :model_data
          get :data_by
          get :pay_review
          get :fee_user_analyze
          get :reg_charge
          get :income_channel
          get :income_by
          get :pay_rate_by
        end
      end
      resources :channels, only: [:index]


    end
  end
end

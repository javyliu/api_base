Rails.application.routes.draw do
  #api definition
  namespace :api, defaults: {format: :json}  do
    namespace :v1 do
      resources :infos, only: [:show, :index]
      resources :users, only: [:show, :create, :update, :destroy]
      resources :tokens, only: [:create]
      resources :products
      resources :orders, only: [:index,:show, :create]
      resources :reports, only: [:index] do
        collection do
          get :real_time_data
          get :accounts_gt_money
          get :new_player_analyse
          get :income_analyse
          get :income_month
          get :income_partner
          get :income_haiwai
          get :active_analyse
          get :online_analyse
          get :max_online_analyse
          get :quarter_data
        end
      end
      resources :sessions
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
          get :first_charge_by
          get :activity_preview
          get :activity_by
          get :activity_hour
          get :online_data
          get :avg_online_data
          get :high_online_data
          get :lost_overview
          get :consume_by
          get :synthetic_by
          get :custom_query
          get :consume_query
          get :area_list
        end
      end
      resources :channels


    end
  end
end

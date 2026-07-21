Rails.application.routes.draw do

  get "admins/sign_in",
      to: "admin/authentication_sessions#new",
      as: :new_admin_session

  post "admins/sign_in",
       to: "admin/authentication_sessions#create",
       as: :admin_session

  delete "admins/sign_out",
         to: "admin/authentication_sessions#destroy",
         as: :destroy_admin_session

  get "customers/sign_in",
      to: "public/authentication_sessions#new",
      as: :new_customer_session

  post "customers/sign_in",
       to: "public/authentication_sessions#create",
       as: :customer_session

  delete "customers/sign_out",
         to: "public/authentication_sessions#destroy",
         as: :destroy_customer_session

  get "customers/sign_up",
      to: "public/registrations#new",
      as: :new_customer_registration

  post "customers",
       to: "public/registrations#create",
       as: :customer_registration

  post "admins/sign_in",
       to: "admin/authentication_sessions#create",
       as: :admin_session

  delete "admins/sign_out",
         to: "admin/authentication_sessions#destroy",
         as: :destroy_admin_session

  get "customers/sign_in",
      to: "public/authentication_sessions#new",
      as: :new_customer_session

  post "customers/sign_in",
       to: "public/authentication_sessions#create",
       as: :customer_session

  delete "customers/sign_out",
         to: "public/authentication_sessions#destroy",
         as: :destroy_customer_session

  get "customers/sign_up",
      to: "public/registrations#new",
      as: :new_customer_registration

  post "customers",
       to: "public/registrations#create",
       as: :customer_registration

  # 管理者側のルーティング
  namespace :admin do
    root to: "homes#top"

    resources :items, only: [ :index, :new, :create, :show, :edit, :update ]
    resources :genres, only: [ :index, :create, :edit, :update ]
    resources :customers, only: [ :index, :show, :edit, :update ]
    resources :orders, only: [ :show, :update ]
    resources :order_details, only: [ :update ]
  end

  # 顧客側のルーティング（カートや配送先、注文など）
  scope module: :public do
    root to: "homes#top"
    get "about", to: "homes#about"

    resources :items, only: [ :index, :show ]

    get "customers/my_page", to: "customers#show"
    get "customers/information/edit", to: "customers#edit"
    patch "customers/information", to: "customers#update"
    get "customers/unsubscribe", to: "customers#unsubscribe"
    patch "customers/withdraw", to: "customers#withdraw"

    resources :cart_items, only: [ :index, :create, :update, :destroy ] do
      delete :destroy_all, on: :collection
    end

    resources :orders, only: [ :new, :create, :index, :show ] do
      post :confirm, on: :collection
      get :complete, on: :collection
    end

    resources :addresses, only: [ :index, :edit, :create, :update, :destroy ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
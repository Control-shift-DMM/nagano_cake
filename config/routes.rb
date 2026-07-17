Rails.application.routes.draw do
  namespace :admin do
    root to: "homes#top"

    resources :items, only: [ :index, :new, :create, :show, :edit, :update ]
    resources :genres, only: [ :index, :create, :edit, :update ]
    resources :customers, only: [ :index, :show, :edit, :update ]
    resources :orders, only: [ :show, :update ]
    resources :order_details, only: [ :update ]
  end

  scope module: :public do
    root to: "homes#top"
    get "about", to: "homes#about"

    resource :session
    resources :passwords, param: :token

    resources :customers, only: [:new, :create] do
      collection do
        get "my_page", to: "customers#show"
        get "information/edit", to: "customers#edit"
        patch "information", to: "customers#update"
        get "unsubscribe", to: "customers#unsubscribe"
        patch "withdraw", to: "customers#withdraw"
      end
    end

    resources :items, only: [ :index, :show ]

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

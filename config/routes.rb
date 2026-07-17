Rails.application.routes.draw do
  devise_for :admins,
             skip: [:registrations, :passwords],
             controllers: {
               sessions: "admin/sessions"
             }

  devise_for :customers,
             skip: [:passwords],
             controllers: {
               registrations: "public/registrations",
               sessions: "public/sessions"
             }

  namespace :admin do
    root to: "homes#top"
  end

  scope module: :public do
    root to: "homes#top"
    get "about", to: "homes#about"

    resources :items, only: [:index, :show]
  end
end

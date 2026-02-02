Rails.application.routes.draw do
  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # トップページ(仮)
  root "home#index"

  resources :routines, only: [:index, :new, :create, :show] do
    resources :tasks, only: [:create]
    get :execute, on: :member
    patch :reset, on: :member
  end

  resources :tasks, only: [] do
    patch :start, on: :member
    patch :finish, on: :member
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

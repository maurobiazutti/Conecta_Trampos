Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resource :profile, only: [ :show, :new, :create, :edit, :update ]
  resource :address, only: [ :show, :new, :create, :edit, :update ]
  get "quero-contratar", to: "service_requests#start", as: :start_service_requests
  resources :service_requests, only: [ :new, :create ]
end

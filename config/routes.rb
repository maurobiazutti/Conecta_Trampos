Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resource :profile, only: [ :show, :new, :create, :edit, :update ]
  resource :address, only: [ :show, :new, :create, :edit, :update ]
end

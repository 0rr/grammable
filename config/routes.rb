Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "grams#index"

  resources :grams, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    resources :comments, only: [:new, :create]
  end
end

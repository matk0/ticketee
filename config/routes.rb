Rails.application.routes.draw do
  namespace :admin do
  get 'users/index'
  end

  root 'projects#index'

  devise_for :users

  namespace :admin do
    root 'application#index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets
  end
end

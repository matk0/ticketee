Rails.application.routes.draw do

  root 'projects#index'

  devise_for :users

  namespace :admin do
    root 'application#index'
    get 'users/index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
  end

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets do
      member do
        patch :toggle_completed
      end
    end
  end

  resources :attachments, only: [:show, :new]

  resources :tickets, only: [] do
    resources :comments, only: [:create]
  end
end

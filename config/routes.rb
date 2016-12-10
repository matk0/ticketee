require 'heartbeat/application'

Rails.application.routes.draw do
  mount Heartbeat::Application, at: "/heartbeat"

  root 'projects#index'

  devise_for :users

  namespace :api do
    resources :projects, only: [] do
      resources :tickets
    end
  end

  namespace :admin do
    root 'application#index'
    get 'users/index'
    resources :projects, only: [:new, :create, :destroy]
    resources :users do
      member do
        patch :archive
      end
    end
    resources :states, only: [:index, :new, :create] do
      member do
        get :make_default
      end
    end
  end

  resources :projects, only: [:index, :show, :edit, :update] do
    resources :tickets do
      collection do
        get :search
      end
      member do
        post :watch
        patch :toggle_completed
      end
    end
  end

  resources :attachments, only: [:show, :new]

  resources :tickets, only: [] do
    resources :comments, only: [:create]
    resources :tags, only: [] do
      member do
        delete :remove
      end
    end
  end
end

Rails.application.routes.draw do
  devise_for :users
  get 'tickets/index'

  get 'tickets/new'

  get 'tickets/create'

  get 'tickets/update'

  get 'tickets/destroy'

  root 'projects#index'

  resources :projects do
    resources :tickets
  end
end

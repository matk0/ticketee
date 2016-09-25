Rails.application.routes.draw do
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

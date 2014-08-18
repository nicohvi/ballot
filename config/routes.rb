Rails.application.routes.draw do
  root 'polls#new'

  resources :polls do
      resources :options
  end

  # Oatuh paths
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/current_user', to: 'sessions#user'

end

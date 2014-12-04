Rails.application.routes.draw do
  root 'polls#new'

  resources :polls do
    get 'guest', on: :collection 
    member do
      post 'close'
      post 'open'
    end
    resources :options do
      post 'vote'
    end
  end
  
  get '/users/:id/polls', to: 'users#polls', as: 'user_polls'

  # Oatuh paths
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  get '/current_user', to: 'sessions#user'

  # pretty urls
  get ':id', to: 'polls#show'

end

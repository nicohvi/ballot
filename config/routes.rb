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

  resources :users do
    collection do
      post 'login'
    end
    member do 
      get 'created_polls'
      get 'voted_polls'
    end
  end
  
  # Oatuh paths
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  # pretty urls
  get ':id', to: 'polls#show'

end

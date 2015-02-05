Rails.application.routes.draw do
  root 'users#show'

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
      get 'login_form'
      get 'register_form'
      post 'login'
    end
    resources :polls, only: :index
    resources :votes, only: :index
  end

  resources :password_resets, param: :token

  post '/inbound', to: 'emails#handle'
  
  # Oatuh paths
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  # pretty urls
  get ':id', to: 'polls#show'

end

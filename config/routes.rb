Rails.application.routes.draw do
  root 'polls#index'

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
  
  #resources :users, only: :index do
    #resources :polls, only: :index
  #end  
  get '/users/:id/polls', to: 'users#polls', as: 'user_polls'

  # Oatuh paths
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'

  # pretty urls
  get ':id', to: 'polls#show'

end

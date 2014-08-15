Rails.application.routes.draw do
  root 'polls#new'

  resources :polls do
      resources :options
  end

end

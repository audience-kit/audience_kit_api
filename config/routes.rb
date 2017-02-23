Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :token, to: 'token#create'

  get :me, :to => 'users#me'
  get :now, :to => 'venues#now'

  get '/locales/closest' => 'locales#closest'
  get '/venues/closest' => 'venues#closest'
  get '/venues/:id/friends' => 'venues#friends'

  post '/me/location', :to => 'users#location'

  resources :events

  resources :venues do
    resources :events
  end



  resources :locales do
    resources :venues do
      resources :events
    end

    resources :events

    resources :people
  end

  root to: 'status#index'
end

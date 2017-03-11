Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :token, to: 'token#create'

  get :me, :to => 'users#me'
  get :now, :to => 'venues#now'

  get '/locales/closest' => 'locales#closest'
  get '/venues/closest' => 'venues#closest'
  get '/venues/:id/friends' => 'venues#friends'

  post '/me/location', :to => 'users#location'
  post '/callbacks/facebook/user', :to => 'callbacks#facebook_user'
  post '/callbacks/facebook/page', :to => 'callbacks#facebook_page'
  post '/callbacks/facebook/deauthorize', :to => 'callbacks#facebook_deauthorize'

  resources :events

  resources :venues do
    resources :events

    member do
      get :photo
    end
  end

  resources :locales do
    resources :venues do
      resources :events
    end

    resources :events

    resources :people

    member do
      get :photo
    end
  end

  resources :people

  root to: 'status#index'
end

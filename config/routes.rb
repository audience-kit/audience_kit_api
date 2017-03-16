Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :token, to: 'token#create'

  get :me, :to => 'users#me'
  get :now, :to => 'venues#now'

  get '/locales/closest' => 'locales#closest'
  get '/venues/closest' => 'venues#closest'
  get '/venues/:id/friends' => 'venues#friends'

  post '/me/location', :to => 'users#location'

  resources :events, only: [ :index, :show ]

  resources :venues, only: [ :index, :show ] do
    resources :events, only: [ :index, :show ]

    member do
      get :photo
    end

    collection do
      get :here
    end
  end

  resources :locales, only: [ :index, :show ] do
    resources :venues, only: [ :index ]

    resources :events, only: [ :index ]

    resources :people, only: [ :index ]

    member do
      get :photo
    end
  end

  resources :people, only: [ :index, :show ]

  resources :tracks, only: [ :show ] do
    member do
      get :artwork
      get :waveform
    end
  end

  namespace :callbacks do
    namespace :facebook do
      post :user, :to => '/callbacks#facebook_user'
      post :page, :to => '/callbacks#facebook_page'
      get :user, :to => '/callbacks#facebook_verify'
      get :page, :to => '/callbacks#facebook_verify'
      post :deauthorize, :to => '/callbacks#facebook_deauthorize'
    end
  end


  root to: 'status#index'
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :token, to: 'token#create'
  post '/token/device', to: 'token#device'

  mount ActionCable.server => '/connection'

  get :me, :to => 'users#me'
  get :now, :to => 'venues#now'

  get '/locales/closest' => 'locales#closest'
  get '/venues/closest' => 'venues#closest'

  post '/me/location', :to => 'users#coordinates'

  resources :locales, only: [ :index, :show ], shallow: true do

    resources :venues, only: [ :index, :show ], shallow: true do
      collection do
        get :here
        get :closest
      end

      member do
        get :photo
        get :picture
        get :cover
        get :friends
        get :events
      end

    end

    resources :events, only: [ :index, :show ], shallow: true do
      member do
        post :rsvp
      end
    end

    resources :people, only: [ :index, :show ], shallow: true do
      member do
        get :picture
        get :cover
        get :events
      end

      resources :tracks, only: [ :show ], shallow: true do
        member do
          get :artwork
          get :waveform
        end
      end
    end

    member do
      get :photo
    end
  end

  resources :users, only: [ :show ] do
    member do
      get :picture
    end
  end

  resources :photos, only: [ :show ]

  resources :tracks, only: [ :show ]

  resources :events, only: [ :index ]

  namespace :callbacks do
    namespace :facebook do
      post :user, :to => '/callbacks#facebook_user'
      post :page, :to => '/callbacks#facebook_page'
      get :user, :to => '/callbacks#facebook_verify'
      get :page, :to => '/callbacks#facebook_verify'
      post :revoke, :to => '/callbacks#facebook_deauthorize'
    end
  end

  root to: 'status#index'
end

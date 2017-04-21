# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/connection'

  scope '/v1' do
    post :token, to: 'token#create'
    post '/token/device', to: 'token#device'

    get :me, to: 'users#me'
    get :now, to: 'venues#now'

    get '/locales/closest' => 'locales#closest'
    get '/venues/closest' => 'venues#closest'

    post '/me/location', to: 'users#coordinates'

    resources :locales, only: %i[index show], shallow: true do

      resources :venues, only: %i[index show], shallow: true do
        collection do
          get :here
          get :closest
        end

        get :events, on: :member
      end

      resources :events, only: %i[index show], shallow: true do
        post :rsvp, on: :member
      end

      resources :people, only: %i[index show], shallow: true do
        get :events, on: :member

        resources :tracks, only: [:show], shallow: true
      end
    end

    resources :users, only: [:show]
    resources :photos, only: [:show]
    resources :tracks, only: [:show]
    resources :events, only: [:index]
  end

  namespace :callbacks do
    namespace :facebook do
      post :user, to: '/callbacks#facebook_user'
      post :page, to: '/callbacks#facebook_page'
      get :user, to: '/callbacks#facebook_verify'
      get :page, to: '/callbacks#facebook_verify'
      post :revoke, to: '/callbacks#facebook_deauthorize'
    end
  end

  get :alexa, to: 'alexa#index'

  root to: 'status#index'
end

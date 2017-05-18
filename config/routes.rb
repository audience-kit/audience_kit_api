# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => '/connection'

  scope '/v1' do
    post :token, to: 'token#create'
    post '/token/device', to: 'token#device'

    get :me, to: 'users#me'
    get :now, to: 'venues#now'

    post '/me/location', to: 'users#coordinates'

    resources :locales, only: %i[index show], shallow: true do
      get :closest, on: :collection

      resources :venues, only: %i[index show], shallow: true do
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
      post :user
      post :page
      get :user, action: :verify
      get :page, action: :verify
      post :revoke
    end
  end

  namespace :alexa do
    get :events
    get :friends
  end

  root to: 'status#index', via: [ :get, :post ]
end

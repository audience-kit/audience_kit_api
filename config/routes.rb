Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post :token, to: 'token#create'

  get :me, :to => 'users#me'

  resources :events

  resources :venues do
    resources :events
  end

  get '/locales/closest' => 'locales#closest'
  resources :locales do
    resources :venues do
      resources :events
    end

    resources :events
  end

  root to: 'status#index'
end

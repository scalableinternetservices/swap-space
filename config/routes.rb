Rails.application.routes.draw do
  get 'sessions/new'

  resources :items do
    post '/trade/:bid_id', on: :member, to: 'items#add_trade', as: 'add_trade'
    post '/cancel/:bid_id', on: :member, to: 'items#cancel_bid', as: 'cancel_bid'
  end

  get 'users/new'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :articles
  get '/result', to: 'searchresults#result'

  # articleモデルのルーティング追加。記事1つの詳細(記事本体など)を表示する
  # URL: https://railsguides.jp/routing.html?version=6.0#restful%E3%81%AA%E3%82%A2%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E3%81%95%E3%82%89%E3%81%AB%E8%BF%BD%E5%8A%A0%E3%81%99%E3%82%8B
  resources :articles do
    member do
      get 'browsing'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

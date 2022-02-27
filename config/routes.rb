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
  resources :articles, except: :index
  resources :questions, except: :index
  resources :relationships, only: [:create, :destroy]
  resources :nice_to_articles, only: [:create, :destroy]
  resources :article_bookmarks, only: [:create, :destroy]
  resources :question_bookmarks, only: [:create, :destroy]
  resources :curious_questions, only: [:create, :destroy]
  resources :article_comments, only: [:create, :destroy]
  # articleモデルのルーティング「1つ」追加。記事1つの詳細(記事本体など)を表示する
  # 本当に必要なルーティングのみを生成することで、メモリ使用量の節約とルーティングプロセスの速度向上が見込めます。[railsガイド抜粋]
  # URL: https://railsguides.jp/routing.html?version=6.0#%E3%83%AA%E3%82%BD%E3%83%BC%E3%82%B9%E3%83%95%E3%83%AB%E3%81%A7%E3%81%AA%E3%81%84%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0
  # URL: https://railsguides.jp/routing.html?version=6.0#%E5%90%8D%E5%89%8D%E4%BB%98%E3%81%8D%E3%83%AB%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0
  get 'user/:id/following', to: 'users#following', as: :user_following
  get 'user/:id/follower', to: 'users#follower', as: :user_follower

  get 'articles/:id/browsing', to: 'articles#browsing', as: :browsing_article
  get 'questions/:id/browsing', to: 'questions#browsing', as: :browsing_question

  get 'user/:id/nice', to: 'users#nice', as: :user_nice
  get 'user/:id/bookmark', to: 'users#bookmark', as: :user_bookmark
  get 'user/:id/curious', to: 'users#curious', as: :user_curious
  get 'user/:id/questionbookmark', to: 'users#questionbookmark', as: :user_questionbookmark

  get '/result', to: 'searchresults#result'
  get '/searchresults/:id/personalarticle', to: 'searchresults#personalarticle', as: :searchresult_parsonal_article
  get '/searchresults/:id/personalquestion', to: 'searchresults#personalquestion', as: :searchresult_parsonal_question
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

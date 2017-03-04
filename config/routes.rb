Rails.application.routes.draw do
 
  get 'microposts/create'

  get 'microposts/destroy'

  get 'password_resets/new'

  get 'password_resets/edit'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'sessions/new'

  get 'users/new'

  get '/help' => "static_pages#help"

  get '/about' => "static_pages#about"

  get '/contact' => "static_pages#contact"

  get '/signup' => "users#new"

  post '/signup' => "users#create"

  root 'static_pages#home'

  get '/login' => "sessions#new"

  post '/login' => "sessions#create"

  delete '/logout' => "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only:[:create, :destroy]

  resources :account_activations, only:[:edit]

  resources :password_resets, only:[:new, :create, :edit, :update]

  resources :microposts, only:[:create, :destroy]

end

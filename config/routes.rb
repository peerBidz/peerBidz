BestBay::Application.routes.draw do


  devise_for :admins

  devise_for :users

  resources :items
  resources :users

  match '/allusers',  :to => 'users#index'
  match '/contact', :to => 'pages#contact'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'

  match '/welcome',   :to => 'pages#adminHome'

  root :to => 'pages#home'

  match '/admin' => "welcome#index", :as => :admin_root



end

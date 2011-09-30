BestBay::Application.routes.draw do


  devise_for :users

  match '/register',  :to => 'users#new'
  match '/contact', :to => 'pages#contact'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'

  root :to => 'pages#home'



end

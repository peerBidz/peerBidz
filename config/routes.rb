BestBay::Application.routes.draw do |map|

  get "line_items/create"

  get "carts/new"

  resources :orders

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :categories
  resources :biddings
  resources :searches
  resources :notifications

  #commenting out categories so no one edits/deletes them - CD
  #resources :categories
  devise_for :users  

  resources :items
  resources :users

  #ActiveAdmin.routes(self)

  #devise_for :admin_users, ActiveAdmin::Devise.config

  #Cart and Order
  map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'

  resources :line_items
  resources :carts


  match '/contacts', :to => 'pages#contact'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'
  match '/advsearch',  :to => 'searches#new'
  match '/information',  :to => 'orders#new'

  root :to => 'pages#home'

end

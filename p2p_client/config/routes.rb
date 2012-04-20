BestBay::Application.routes.draw do |map|

  resources :items do
  member do
    get 'add_to_watch_list'
    get 'remove_from_watch_list'
  end
end

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

  match '/initauction', :to => 'items#initauction'
  match '/payment', :to => 'pages#payment'
  match '/contacts', :to => 'pages#contact'
  match '/myaccount', :to => 'pages#myaccount'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'
  match '/advsearch',  :to => 'searches#new'
  match '/information',  :to => 'orders#new'

  match '/items/:id/add_to_watch_list', :to => 'items#add_to_watch_list'
  match '/items/:id/remove_from_watch_list', :to => 'items#remove_from_watch_list'
  match '/items/:id', :to => 'items#show'
  match '/table', :to => 'items#table'

  root :to => 'pages#home'

  match '/api/xmlrpc' => 'rpc#xe_index'







end

BestBay::Application.routes.draw do

  resources :items do
  member do
    get 'add_to_watch_list'
  end
end

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


  match '/myaccount', :to => 'pages#myaccount'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'
  match '/advsearch',  :to => 'searches#new'

  match '/items/:id/add_to_watch_list', :to => 'items#add_to_watch_list'

  root :to => 'pages#home'







end

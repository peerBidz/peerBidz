BestBay::Application.routes.draw do

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


  match '/contact', :to => 'pages#contact'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'
  match '/advsearch',  :to => 'searches#new'

  root :to => 'pages#home'

end

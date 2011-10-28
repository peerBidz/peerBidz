BestBay::Application.routes.draw do

  #ActiveAdmin.routes(self)

  #devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  #commenting out categories so no one edits/deletes them - CD
  #resources :categories
  resources :items
  resources :users

  match '/contact', :to => 'pages#contact'
  match '/items',   :to => 'pages#items'
  match '/help',    :to => 'pages#help'
  match '/about',   :to => 'pages#about'
  match '/search', :to => 'pages#search'

  root :to => 'pages#home'

end

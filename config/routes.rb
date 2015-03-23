Rails.application.routes.draw do

  root 'pages#home'

  ActiveAdmin.routes(self)

  get "admin/topics/:id/children/new" => "admin/topics#new", as: :new_admin_child_topic
  get 'search/' => 'search#search'
  get 'search/autocomplete' => 'search#autocomplete'

  devise_for :users

  resources :topics, only: [:show] do
    resources :instructionals, only: [:show, :new, :create]
  end

  resources :instructionals, only: [:show]
end

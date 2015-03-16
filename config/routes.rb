Rails.application.routes.draw do
  root 'pages#home'

  ActiveAdmin.routes(self)

  get "admin/topics/:id/children/new" => "admin/topics#new", as: :new_admin_child_topic

  devise_for :users

  resources :topics, only: [:show] do
    resources :instructionals, only: [:show]
  end

  resources :instructionals, only: [:show]
end

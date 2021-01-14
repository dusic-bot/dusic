Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin/rails', as: 'rails_admin'

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  devise_scope :user do
    get 'signin', to: 'users/sessions#new', as: :signin
    post 'signin', to: 'users/sessions#create'
    delete 'signout', to: 'users/sessions#destroy', as: :signout
    get 'signup', to: 'users/registrations#new', as: :signup
  end

  root to: 'pages#root'
end

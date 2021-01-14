Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin/rails', as: 'rails_admin'

  devise_for :users, controllers: { sessions: 'users/sessions' }
  devise_scope :user do
    get 'signin', to: 'devise/sessions#new', as: :signin
    post 'signin', to: 'devise/sessions#create'
    delete 'signout', to: 'devise/sessions#destroy', as: :signout
    get 'signup', to: 'devise/registrations#new', as: :signup
  end

  root to: 'pages#root'
end

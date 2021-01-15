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

  namespace :admin do
    get '/', to: 'pages#root'

    get '/donation_id', to: 'pages#donation_id', as: :donation_id
    post '/donation_id', to: 'pages#donation_id_convert'
  end
end

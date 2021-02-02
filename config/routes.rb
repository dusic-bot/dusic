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

    get '/audios', to: 'pages#audios', as: :audios
    get '/audio', to: 'pages#audio', as: :audio
  end

  namespace :api do
    namespace :v2 do
      resources :servers, only: %i[index show update]

      get '/audios/', to: 'audios#index', as: :audios
      get '/audios/:manager/:id', to: 'audios#show', as: :audio
    end
  end
end

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin/rails', as: 'rails_admin'
  mount Blazer::Engine => '/admin/blazer', as: 'blazer'
  mount ActionCable.server => '/ws', as: 'websocket'

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

    match '/jwt_token', to: 'pages#jwt_token', via: %i[get post], as: :jwt_token
    match '/websocket_server', to: 'pages#websocket_server', via: %i[get post], as: :websocket_server
    match '/donation_adder', to: 'pages#donation_adder', via: %i[get post], as: :donation_adder
    match '/command_executor', to: 'pages#command_executor', via: %i[get post], as: :command_executor

    resources :audios, only: %i[index] do
      collection do
        get '/:manager/:id', to: 'audios#show', as: :audio
      end
    end
  end

  namespace :api do
    namespace :v2 do
      resources :discord_servers, only: %i[index show update]

      resources :audios, only: %i[index] do
        collection do
          get '/:manager/:id', to: 'audios#show', as: :audio
        end
      end

      resources :command_calls, only: %i[create]
    end
  end
end

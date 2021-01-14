Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin/rails', as: 'rails_admin'
  devise_for :users, controllers: { sessions: 'users/sessions' }

  root to: 'pages#root'
end

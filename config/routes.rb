require 'sidekiq/web'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  #   username == 'admin' && password == 'password' # Change these credentials
  # end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :v1 do 
    resources :application do
      resources :chats do
        get 'messages-search', to: 'messages#search'
        resources :messages
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'


end

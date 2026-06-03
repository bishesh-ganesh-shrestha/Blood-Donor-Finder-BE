Rails.application.routes.draw do
  mount_avo
  devise_for :users,
    controllers: {
      sessions: "users/sessions",
      registrations: "users/registrations"
    }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  scope :avo do
    get  "dashboard",        to: "avo/tools#dashboard",        as: :avo_dashboard
    get  "export_requests",  to: "avo/tools#export_requests",  as: :avo_export_requests
  end


  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resource :donor_profile, only: [ :create, :show, :update ]
      resources :donor_profiles, only: [ :index ]
      resources :blood_requests, only: [ :create, :index, :show ] do
        member do
          get :matching_donors
        end

        collection do
          get :my_requests
        end
      end

      resources :blood_donation_requests, only: [ :create, :update, :index, :show ] do
        member do
          patch :update_location
        end
      end

      resources :notifications, only: [ :index ] do
        member do
          patch :mark_as_read
        end
        collection do
          patch :read_all
        end
      end
    end
  end
end

if defined? ::Avo
  Avo::Engine.routes.draw do
    # This route is not protected, secure it with authentication if needed.
    get "dashboard", to: "tools#dashboard", as: :dashboard
  end
end

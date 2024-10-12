Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/project/'
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        sessions: "api/v1/sessions",
        passwords: "api/v1/passwords",
        registrations: "api/v1/registrations"
      }

      resources :users, only: [] do
        collection do
          get :me
          patch :me, to: "users#update"
        end
      end

      resources :airports, only: [:index]
      resources :flights, only: [:index, :show] do
        member do
          get :seat_availabilities
          get :pricings
        end
      end
      resources :bookings, only: [:create] do
        collection do
          get :logic
        end
      end
    end
  end

  namespace :admin do
    mount_devise_token_auth_for 'Administrator', at: '/', controllers: {
      sessions: "admin/sessions",
      passwords: "api/v1/passwords"
    }

    resources :administrators, only: [] do
      collection do
        get :me
        patch :me, to: "administrators#update"
      end
    end

    resources :airports, only: [:index]
    resources :aircrafts, only: [:index]
    resources :flights, only: [:index, :show, :create, :destroy] do
      member do
        get :seat_availabilities
        get :pricings
        post :pricings, to: "flights#create_update_price"
      end
    end
  end
end

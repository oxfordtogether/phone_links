Rails.application.routes.draw do
  root to: "pages#home"

  get "login", to: "login#show"
  get "invalid_permissions", to: "login#invalid_permissions"
  get "logout", to: "logout#logout"
  get "auth/auth0/callback" => "auth0#callback"
  get "auth/failure" => "auth0#failure"

  resources :people, only: %i[show new create edit update]
  resources :caller, only: %i[new create edit update]

  get "waitlist" => "waitlist#index"
end

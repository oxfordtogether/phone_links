Rails.application.routes.draw do
  root to: "pages#home"

  get "login", to: "login#show"
  get "invalid_permissions", to: "login#invalid_permissions"
  get "logout", to: "logout#logout"
  get "auth/auth0/callback" => "auth0#callback"
  get "auth/failure" => "auth0#failure"

  resources :people, only: %i[show new create edit update] do
    member do
      get :events
      get :details
      get :new_role
      post :create_role
    end
  end

  resources :caller, only: %i[new create edit update]
  resources :callee, only: %i[new create edit update]
  resources :matches, only: %i[show new create edit update]
  resources :pods, only: %i[show index new create edit update]

  get "waitlist" => "waitlist#index"
  get "waitlist/callers" => "waitlist#callers"
  get "waitlist/callees" => "waitlist#callees"
  get "waitlist/provisional_matches" => "waitlist#provisional_matches"
end

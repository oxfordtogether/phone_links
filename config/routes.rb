Rails.application.routes.draw do
  root to: "pages#home"
  get "support", to: "pages#support"
  get "search", to: "pages#search"
  get "admin", to: "pages#admin"
  get "admin/admins", to: "pages#admins"
  get "admin/pod_leaders", to: "pages#pod_leaders"
  get "admin/callers", to: "pages#callers"
  get "admin/new_user", to: "pages#new_user"

  get "login", to: "login#show"
  get "invalid_permissions", to: "login#invalid_permissions"
  get "logout", to: "logout#logout"
  get "auth/auth0/callback" => "auth0#callback"
  get "auth/failure" => "auth0#failure"

  resources :people, only: %i[show new create edit update] do
    member do
      get :disambiguate
      get :events
      get :details
      get :new_role
      post :create_role

      get "caller/new", to: "callers#new"
    end
  end

  resources :callers, only: %i[new create edit update]

  resources :callees, only: %i[new create edit update]
  resources :matches, only: %i[show new create edit update]
  resources :pods, only: %i[show index new create edit update] do
    member do
      get :matches
      get :callers
      get :callees
    end
  end

  get "waitlist" => "waitlist#index"
  get "waitlist/callers" => "waitlist#callers"
  get "waitlist/callees" => "waitlist#callees"
  get "waitlist/provisional_matches" => "waitlist#provisional_matches"
end

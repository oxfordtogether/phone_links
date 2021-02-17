Rails.application.routes.draw do
  root to: "home#home"

  get "login", to: "login#show"
  get "logout", to: "logout#logout"
  get "auth/auth0/callback" => "auth0#callback"
  get "auth/failure" => "auth0#failure"
  get "invalid_permissions_for_app", to: "login#invalid_permissions_for_app"
  get "invalid_permissions_for_page", to: "login#invalid_permissions_for_page"
  get "page_does_not_exist", to: "login#page_does_not_exist"

  namespace :a do
    get "/", to: "pages#home"

    get "support", to: "pages#support"
    get "search", to: "pages#search"
    get "admin", to: "pages#admin"
    get "admin/admins", to: "admins#index"
    get "admin/pod_leaders", to: "pod_leaders#index"
    get "admin/callers", to: "pages#callers"
    get "form_responses", to: "pages#form_responses"

    # need this to get search to work on people/new after failed validation in form
    get "people" => "people#new"

    resources :people, only: %i[show new create edit update] do
      member do
        get :events
        get :details
        get :actions

        get "callee/new", to: "callees#new"
        get "caller/new", to: "callers#new"
        get "admin/new", to: "admins#new"
        get "pod_leader/new", to: "pod_leaders#new"
      end
    end

    resources :callees, only: %i[new create edit update]
    resources :callers, only: %i[new create edit update]
    resources :admins, only: %i[create]
    resources :pod_leaders, only: %i[create]

    resources :callees, only: %i[new create edit update]
    resources :matches, only: %i[show new create edit update]

    resources :pods, only: %i[show index new create edit update] do
      member do
        get :matches
        get :callers
        get :callees

        get "match/new", to: "matches#new"
      end
    end

    get "waitlist" => "waitlist#index"
    get "waitlist/callers" => "waitlist#callers"
    get "waitlist/callees" => "waitlist#callees"
    get "waitlist/provisional_matches" => "waitlist#provisional_matches"
  end

  namespace :pl do
    scope "/:pod_leader_id" do
      get "/", to: "pages#home"
    end
  end

  namespace :c do
    scope "/:caller_id" do
      get "/", to: "pages#home"
    end
  end
end

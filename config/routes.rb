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
        get :actions

        scope path: :edit, as: :edit do
          get :personal_details
          post :personal_details, action: :save_personal_details, as: :save_personal_details
          get :contact_details
          post :contact_details, action: :save_contact_details, as: :save_contact_details
          get :flag
          post :flag, action: :save_flag, as: :save_flag
          get :referral_details
          post :referral_details, action: :save_referral_details, as: :save_referral_details
          get :experience
          post :experience, action: :save_experience, as: :save_experience
          get :pod_membership
          post :pod_membership, action: :save_pod_membership, as: :save_pod_membership
          get :active
          post :active, action: :save_active, as: :save_active
          get :emergency_contacts
          post :emergency_contacts, action: :save_emergency_contacts, as: :save_emergency_contacts
        end

        resources :notes, only: %i[new create]

        get "callee/new", to: "callees#new"
        get "caller/new", to: "callers#new"
        get "admin/new", to: "admins#new"
        get "pod_leader/new", to: "pod_leaders#new"
      end
    end

    post "emergency_contacts/:id", to: "emergency_contacts#update"
    delete "emergency_contacts/:id", to: "emergency_contacts#destroy"

    resources :notes, only: %i[edit update destroy]
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

      get "support", to: "pages#support"

      resources :reports, only: %i[index show]
      post "/reports/:id", to: "reports#update"

      resources :people, only: %i[show] do
        member do
          get "/notes/new", to: "notes#new"
          post "/notes", to: "notes#create"
        end
      end

      resources :callers, only: %i[index]
      resources :callees, only: %i[index]
      resources :matches

      resources :notes, only: %i[edit update destroy]
    end
  end

  namespace :c do
    scope "/:caller_id" do
      get "/", to: "pages#home"
      get "support", to: "pages#support"
      resources :reports
      resources :callees
    end
  end
end

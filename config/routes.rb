Rails.application.routes.draw do
  root to: "home#home"

  get "login", to: "login#show"
  get "logout", to: "logout#logout"
  get "auth/auth0/callback" => "auth0#callback"
  get "auth/failure" => "auth0#failure"
  get "invalid_permissions_for_app", to: "login#invalid_permissions_for_app"
  get "invalid_permissions_for_page", to: "login#invalid_permissions_for_page"
  get "page_does_not_exist", to: "login#page_does_not_exist"
  get "unverified_email", to: "login#unverified_email"

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
        post "create_role", to: "people#create_role"

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
          get :emergency_contacts
          post :emergency_contacts, action: :save_emergency_contacts, as: :save_emergency_contacts
          post :invite, action: :save_invite, as: :save_invite
        end

        resources :notes, only: %i[new create]
      end
    end

    resources :callees, only: %i[] do
      member do
        scope path: :edit, as: :edit do
          get :status
          post :status, action: :save_status, as: :save_status
        end
      end
    end

    resources :callers, only: %i[] do
      member do
        scope path: :edit, as: :edit do
          get :status
          post :status, action: :save_status, as: :save_status
        end
      end
    end

    resources :pod_leaders, only: %i[] do
      member do
        scope path: :edit, as: :edit do
          get :status
          post :status, action: :save_status, as: :save_status
        end
      end
    end

    resources :admins, only: %i[] do
      member do
        scope path: :edit, as: :edit do
          get :status
          post :status, action: :save_status, as: :save_status
        end
      end
    end

    post "emergency_contacts/:id", to: "emergency_contacts#update"
    delete "emergency_contacts/:id", to: "emergency_contacts#destroy"

    resources :notes, only: %i[edit update destroy]

    resources :matches, only: %i[show new create edit update destroy] do
      member do
        post "activate", to: "matches#activate"
      end
    end

    resources :pods, only: %i[show index new create edit update] do
      member do
        get :matches
        get :callers
        get :callees

        get "match/new", to: "matches#new"
      end
    end

    get "inbox" => "inbox#index"

    get "waitlist" => "waitlist#index"
    get "waitlist/callers" => "waitlist#callers"
    get "waitlist/callees" => "waitlist#callees"
    get "waitlist/provisional_matches" => "waitlist#provisional_matches"

    resources :safeguarding_concerns, only: %i[show index new create edit update]
  end

  namespace :pl do
    resources :pod_leaders, only: %i[show] do
      member do
        resources :pods, only: %i[index]
      end
    end

    resources :pods, only: %i[show] do
      member do
        get "support", to: "pods#support"

        resources :reports, only: %i[index]
        resources :callers, only: %i[index]
        resources :callees, only: %i[index]

        resources :matches, only: %i[index new create]
      end
    end

    resources :people, only: %i[show] do
      member do
        resources :notes, only: %i[new create]
      end
    end

    resources :reports, only: %i[show edit update]

    resources :callers, only: %i[update] do
      member do
        get "status"
      end
    end

    resources :callees, only: %i[update] do
      member do
        get "emergency_contacts"
        get "status"
        get "details"
      end
    end

    resources :matches, only: %i[show edit update]

    resources :notes, only: %i[edit update destroy]
  end

  namespace :c do
    scope "/:caller_id" do
      get "/", to: "pages#home"
      resources :reports, only: %i[new create]
      resources :matches, only: %i[show]
    end
  end
end

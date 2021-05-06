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

  resources :referrals, only: %i[index new create]

  namespace :a do
    get "/", to: "pages#home"

    get "support", to: "pages#support"
    get "search", to: "pages#search"
    get "admin", to: "pages#admin"
    get "admin/admins", to: "admins#index"
    get "admin/pod_leaders", to: "pod_leaders#index"
    get "admin/callers", to: "pages#callers"
    get "form_responses", to: "pages#form_responses"

    resources "analytics", only: %i[index] do
      collection do
        get :dashboard, path: "dashboard/(:filter)", constraints: { filter: /6_months|3_months|1_month|2_weeks/ }, to: "analytics#dashboard"
        get "matches", to: "analytics#matches"
      end
    end

    # need this to get search to work on people/new after failed validation in form
    get "people" => "people#new"

    resources :people, only: %i[show new create edit update] do
      member do
        get :events
        get :actions
        post "create_role", to: "people#create_role"

        get :edit, path: "edit(/:page)"
        scope path: :edit, as: :edit do
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

        get :pod_supporters
        post "save_pod_supporters" => "pods#save_pod_supporters"

        get "match/new", to: "matches#new"
      end
    end

    resources :pod_supporters, only: %i[destroy]

    get "inbox" => "inbox#index"

    get "waitlist" => "waitlist#index"
    get "waitlist/callers" => "waitlist#callers"
    get "waitlist/callees" => "waitlist#callees"
    get "waitlist/provisional_matches" => "waitlist#provisional_matches"

    resources :safeguarding_concerns, only: %i[show index new create edit update]

    resources :referrals, only: %i[show index edit update] do
      member do
        post "new_callee" => "referrals#new_callee"
      end
    end
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
        resources :callers, only: %i[index] do
          collection do
            get :interactions
            get :alerts
          end
        end
        resources :callees, only: %i[index]

        resources :matches, only: %i[index new create]

        get "reporting", to: "reporting#pod_reporting_pdf"
      end
    end

    resources :people, only: %i[show update edit] do
      member do
        resources :notes, only: %i[new create]

        get :edit, path: "edit(/:page)"
      end
    end

    resources :reports, only: %i[show edit update]

    resources :callers, only: %i[update] do
      member do
        get "status"
        post :status, action: :update_status, as: :update_status
      end
    end

    resources :callees, only: %i[update] do
      member do
        get "status"
      end
    end

    resources :matches, only: %i[show edit update] do
      member do
        get :edit, path: "edit(/:page)"
      end
    end

    resources :notes, only: %i[edit update destroy]
  end

  namespace :c do
    resources :callers, only: %i[show]

    resources :matches, only: %i[show] do
      resources :reports, only: %i[new create]
    end
  end
end

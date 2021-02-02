Rails.application.routes.draw do
  root to: "pages#home"

  resources :people, only: %i[show new create edit update]
  resources :caller, only: %i[new create edit update]

  get "waitlist" => "waitlist#index"
end

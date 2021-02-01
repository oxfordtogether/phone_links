Rails.application.routes.draw do
  root to: "pages#home"

  resources :people, only: %i[show new create edit update]
end

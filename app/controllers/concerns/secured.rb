module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  def logged_in_using_omniauth?
    return true if !Rails.env.production? && ENV["BYPASS_AUTH"] == "true"

    unless session[:userinfo].present?
      redirect_to("/login", turbolinks: false)
      return
    end

    redirect_to("/invalid_permissions", turbolinks: false) unless session["admin_id"].present?
  end

  def auth0_user
    session[:userinfo]
  end
end

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

    # TO DO
    # app_metadata = session[:userinfo][:extra]["raw_info"]["https://oxfordtogether.org/claims/app_metadata"]
    # has_tenant = if app_metadata
    #                app_metadata["authorization"]["tenants"].include?("...app-tenant...")
    #              else
    #                false
    #              end

    permissions = session[:userinfo]["extra"]["raw_info"]["https://oxfordtogether.org/claims/permissions"]
    has_permissions = permissions.include?("access:oxford-hub-phone-links")

    redirect_to("/invalid_permissions", turbolinks: false) unless has_permissions
  end

  def auth0_user
    session[:userinfo]
  end
end

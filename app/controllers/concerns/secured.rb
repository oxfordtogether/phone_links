module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  def bypass_auth?
    return true if !Rails.env.production? && ENV["BYPASS_AUTH"] == "true"
  end

  def logged_in_using_omniauth?
    return if bypass_auth?

    unless session[:userinfo].present?
      redirect_to("/login", turbolinks: false)
      return
    end

    redirect_to("/invalid_permissions", turbolinks: false) unless session[:admin_id].present? || session[:pod_leader_id].present? || session[:caller_id].present?
  end

  def admin_only
    return if bypass_auth?

    redirect_to "/invalid_permissions" unless session[:admin_id].present?
  end

  def pod_leader_only
    return if bypass_auth?

    redirect_to "/invalid_permissions" unless session[:pod_leader_id].present?
  end

  def caller_only
    return if bypass_auth?

    redirect_to "/invalid_permissions" unless session[:caller_id].present?
  end

  def auth0_user
    session[:userinfo]
  end
end

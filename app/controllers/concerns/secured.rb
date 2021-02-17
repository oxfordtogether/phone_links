module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?
  end

  def bypass_auth?
    return true if !Rails.env.production? && ENV["BYPASS_AUTH"] == "true"
  end

  def current_admin_id
    session[:admin_id]
  end

  def current_pod_leader_id
    session[:pod_leader_id]
  end

  def current_caller_id
    session[:caller_id]
  end

  def logged_in_using_omniauth?
    return if bypass_auth?

    unless session[:userinfo].present?
      redirect_to("/login", turbolinks: false)
      return
    end

    redirect_to("/invalid_permissions_for_app", turbolinks: false) unless current_admin_id.present? || current_pod_leader_id.present? || current_caller_id.present?
  end

  def auth0_user
    session[:userinfo]
  end
end

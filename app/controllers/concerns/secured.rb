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

    redirect_to("/invalid_permissions", turbolinks: false) unless session[:admin_id].present? || session[:pod_leader_id].present? || session[:caller_id].present?
  end

  def admin_only
    redirect_to "/invalid_permissions" unless session[:admin_id].present?
  end

  def pod_leader_only
    redirect_to "/invalid_permissions" unless session[:pod_leader_id].present?
  end

  def caller_only
    redirect_to "/invalid_permissions" unless session[:caller_id].present?
  end

  def auth0_user
    session[:userinfo]
  end
end

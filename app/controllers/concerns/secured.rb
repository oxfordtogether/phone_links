module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in_using_omniauth?, :set_current
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

    return true if current_admin_id.present? || current_pod_leader_id.present? || current_caller_id.present?

    if session[:auth0_id].nil?
      redirect_to("/login", turbolinks: false)
    elsif !session[:email_verified]
      redirect_to("/unverified_email", turbolinks: false)
    else
      # we've got a auth0_id and a verified email, so we're just not connected to a person
      redirect_to("/invalid_permissions_for_app", turbolinks: false)
    end
  end

  def auth0_user
    session[:userinfo]
  end

  private

  def set_current
    Current.person_id = if bypass_auth?
                          Person.first.id
                        else
                          session[:person_id]
                        end
  end
end

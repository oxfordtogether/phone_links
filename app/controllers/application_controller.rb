class ApplicationController < ActionController::Base
  before_bugsnag_notify :add_user_info_to_bugsnag

  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper
  include Pagy::Backend

  include Secured

  default_form_builder OclTools::TailwindFormBuilder

  before_action :set_current_user, :is_admin, :is_pod_leader, :is_caller

  def current_user
    Person.find(session[:person_id])
  end

  private

  def add_user_info_to_bugsnag(report)
    report.user = {
      auth0_id: current_auth0_id,
      person_id: current_person_id,
    }
  end

  helper_method :demo?
  def demo?
    ENV["DEMO"] == "true" || ENV["DEMO"] == true
  end

  def set_current_user
    @current_user = current_user
  end

  def is_admin
    @is_admin ||= current_user&.admin.present?
  end

  def is_pod_leader
    @is_pod_leader ||= current_user&.pod_leader.present?
  end

  def is_caller
    @is_caller ||= current_user&.caller.present?
  end
end

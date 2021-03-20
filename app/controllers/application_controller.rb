class ApplicationController < ActionController::Base
  before_bugsnag_notify :add_user_info_to_bugsnag

  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper
  include Pagy::Backend

  include Secured

  default_form_builder OclTools::TailwindFormBuilder

  def current_user
    if bypass_auth?
      Admin.first.person if Admin.count >= 1
    elsif session[:person_id]
      Person.find(session[:person_id])
    end
  end

  private

  def add_user_info_to_bugsnag(report)
    report.user = {
      auth0_id: current_auth0_id,
      guest_id: current_person_id,
    }
  end

  helper_method :demo?
  def demo?
    ENV["DEMO"] == "true" || ENV["DEMO"] == true
  end
end

class ApplicationController < ActionController::Base
  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper
  include Pagy::Backend

  include Secured

  default_form_builder OclTools::TailwindFormBuilder

  before_action :demo

  def current_user
    if bypass_auth?
      Admin.first.person if Admin.count >= 1
    elsif session[:person_id]
      Person.find(session[:person_id])
    end
  end

  def demo
    @demo ||= ENV["DEMO"]
  end
end

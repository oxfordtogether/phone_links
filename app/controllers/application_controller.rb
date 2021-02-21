class ApplicationController < ActionController::Base
  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper

  include Secured

  default_form_builder OclTools::TailwindFormBuilder

  def current_user
    if bypass_auth?
      Admin.first.person
    elsif session[:person_id]
      Person.find(session[:person_id])
    end
  end
end

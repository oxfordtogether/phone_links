class ApplicationController < ActionController::Base
  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper

  include Secured

  default_form_builder OclTools::TailwindFormBuilder

  def current_user
    Person.find(session[:person_id]) if session[:person_id]
  end
end

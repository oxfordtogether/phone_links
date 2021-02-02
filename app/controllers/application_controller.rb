class ApplicationController < ActionController::Base
  helper OclTools::ComponentsHelper
  helper OclTools::FormHelper

  include Secured

  default_form_builder OclTools::TailwindFormBuilder
end

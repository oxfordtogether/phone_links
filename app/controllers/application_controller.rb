class ApplicationController < ActionController::Base
  helper OclTools::ComponentsHelper
  include Secured
end

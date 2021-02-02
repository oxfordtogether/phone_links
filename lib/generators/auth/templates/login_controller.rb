class LoginController < ApplicationController
  skip_before_action :logged_in_using_omniauth?
  layout "unauthorized"

  def show; end

  def invalid_permissions; end
end

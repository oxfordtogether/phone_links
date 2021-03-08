class LoginController < ApplicationController
  skip_before_action :logged_in_using_omniauth?
  layout "unauthorized"

  def show; end

  def invalid_permissions_for_app; end

  def invalid_permissions_for_page; end

  def page_does_not_exist; end

  def unverified_email; end
end

class A::AController < ApplicationController
  layout "a/layouts/authorized"

  before_action :access_allowed?, :set_current_user

  def access_allowed?
    return if bypass_auth?

    redirect_to "/invalid_permissions_for_page" unless current_admin_id.present?
  end

  def set_current_user
    @current_user = current_user
  end
end

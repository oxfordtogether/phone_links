class C::CController < ApplicationController
  layout "c/layouts/authorized"

  before_action :access_allowed?, :current_caller

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_caller_id.present? && current_caller_id.to_s == params[:caller_id]
  end

  def current_caller
    caller = Caller.find(params[:caller_id])
    @current_caller = caller
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end
end

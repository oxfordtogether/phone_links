class C::CController < ApplicationController
  layout "c/layouts/authorized"

  before_action :access_allowed?, :set_current_caller, :set_fetcher

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_caller_id.present? && current_caller_id.to_s == params[:caller_id]
  end

  def set_current_caller
    @current_caller ||= Caller.find(params[:caller_id])
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end

  def set_fetcher
    @fetcher = C::CallerDataFetcher.new(@current_caller)
  end
end

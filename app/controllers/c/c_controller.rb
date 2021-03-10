class C::CController < ApplicationController
  layout "c/layouts/authorized"

  before_action :access_allowed?, :current_caller, :is_admin, :is_pod_leader, :has_pod

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_caller_id.present? && current_caller_id.to_s == params[:caller_id]
  end

  def current_caller
    @current_caller ||= Caller.find(params[:caller_id])
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end

  def has_pod
    @has_pod ||= current_caller.pod.present?
  end

  def is_admin
    @is_admin ||= current_user&.admin.present?
  end

  def is_pod_leader
    @is_pod_leader ||= current_user&.pod_leader.present?
  end
end

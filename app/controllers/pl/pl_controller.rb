class Pl::PlController < ApplicationController
  layout "pl/layouts/authorized"

  before_action :access_allowed?, :current_pod_leader, :is_admin, :is_caller, :has_pod, :access_only_with_pod?

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_pod_leader_id.present? && current_pod_leader_id.to_s == params[:pod_leader_id]
  end

  def current_pod_leader
    @current_pod_leader ||= PodLeader.with_pod.find(params[:pod_leader_id])
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end

  def is_admin
    @is_admin ||= current_user&.admin.present?
  end

  def is_caller
    @is_caller ||= current_user&.caller.present?
  end

  def has_pod
    @has_pod ||= current_pod_leader.pod.present?
  end

  def access_only_with_pod?
    return if has_pod

    # a pod leader without a pod can not access pages (this is skipped in pages controller so homepage/support is visible)
    redirect_to "/invalid_permissions_for_page"
  end
end

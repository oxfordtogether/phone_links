class Pl::PlController < ApplicationController
  layout "pl/layouts/authorized"

  before_action :access_allowed?, :current_pod_leader, :is_admin

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_pod_leader_id.present? && current_pod_leader_id.to_s == params[:pod_leader_id]
  end

  def current_pod_leader
    @current_pod_leader ||= PodLeader.find(params[:pod_leader_id])
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end

  def is_admin
    @is_admin ||= current_user.admin.present?
  end
end

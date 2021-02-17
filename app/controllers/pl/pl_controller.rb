class Pl::PlController < ApplicationController
  layout "pl/layouts/authorized"

  before_action :access_allowed?, :current_pod_leader

  def access_allowed?
    return if bypass_auth?

    return if current_admin_id.present?

    redirect_to "/invalid_permissions_for_page" unless current_pod_leader_id.present? && current_pod_leader_id.to_s == params[:pod_leader_id]
  end

  def current_pod_leader
    pod_leader = PodLeader.find(params[:pod_leader_id])
    @current_pod_leader = pod_leader
  rescue StandardError
    redirect_to "/page_does_not_exist"
  end
end

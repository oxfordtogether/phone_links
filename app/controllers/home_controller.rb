class HomeController < ApplicationController
  def home
    return redirect_to a_path if bypass_auth?

    if current_admin_id.present?
      redirect_to a_path
    elsif current_pod_leader_id.present?
      redirect_to pl_pod_leader_path(current_pod_leader_id)
    elsif current_caller_id.present?
      redirect_to c_caller_path(current_caller_id)
    else
      redirect_to "/invalid_permissions_for_app"
    end
  end
end

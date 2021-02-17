class HomeController < ApplicationController
  def home
    if current_admin_id.present?
      redirect_to a_path
    elsif current_pod_leader_id.present?
      redirect_to pl_path
    elsif current_caller_id.present?
      redirect_to c_path
    else
      redirect_to "/invalid_permissions"
    end
  end
end

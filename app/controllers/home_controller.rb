class HomeController < ApplicationController
  def home
    if session[:admin_id].present?
      redirect_to a_path
    elsif session[:pod_leader_id].present?
      redirect_to pl_path
    elsif session[:caller_id].present?
      redirect_to c_path
    else
      redirect_to "/invalid_permissions"
    end
  end
end

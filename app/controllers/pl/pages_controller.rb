class Pl::PagesController < Pl::PlController
  def home
    @current_user = current_user
    @current_pod_leader = current_pod_leader
  end
end

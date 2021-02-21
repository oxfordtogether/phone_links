class Pl::CalleesController < Pl::PlController
  before_action :set_callee, only: %i[show]

  def index
    @pod = current_pod_leader.pod
    @current_pod_leader = current_pod_leader
    @callees = Callee.where(pod_id: @pod.id)
  end

  def show
    @person = @callee.person
  end

  private

  def set_callee
    @callee = Callee.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if @callee.pod != current_pod_leader.pod
  end

  def callee_params
    params.require(:callee).permit
  end
end

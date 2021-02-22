class Pl::CallersController < Pl::PlController
  before_action :set_caller, only: %i[show]

  def index
    @pod = current_pod_leader.pod
    @current_pod_leader = current_pod_leader
    @callers = Caller.where(pod_id: @pod.id).where(active: true)
  end

  def show
    @person = @caller.person
  end

  private

  def set_caller
    @caller = Caller.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if @caller.pod != current_pod_leader.pod
  end

  def caller_params
    params.require(:caller).permit
  end
end

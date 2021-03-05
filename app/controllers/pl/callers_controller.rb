class Pl::CallersController < Pl::PlController
  before_action :set_caller_and_person, only: %i[status save_status]

  def index
    @pod = current_pod_leader.pod
    @current_pod_leader = current_pod_leader
    @callers = Caller.where(pod_id: @pod.id).filter { |c| !c.inactive }
  end

  def status
    @caller&.status_change_notes = nil

    render "pl/callers/edit/status"
  end

  def save_status
    @caller.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @caller.save
      RoleStatusChange.create(caller: @caller, status: @caller.status, notes: @caller.status_change_notes, created_by: current_user)

      SearchCacheRefresh.perform_async
      redirect_to pl_person_path(@current_pod_leader, @caller.person), notice: "Caller status was successfully updated."
    else
      render "pl/callers/edit/status"
    end
  end

  private

  def set_caller_and_person
    @caller = Caller.find(params[:id])
    @person = @caller.person

    redirect_to "/invalid_permissions_for_page" if @caller.pod != current_pod_leader.pod
  end

  def status_params
    params.require(:caller).permit(:id, :status, :status_change_notes)
  end
end

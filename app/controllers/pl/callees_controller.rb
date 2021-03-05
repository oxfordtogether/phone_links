class Pl::CalleesController < Pl::PlController
  before_action :set_callee_and_person, only: %i[status save_status]

  def index
    @pod = current_pod_leader.pod
    @current_pod_leader = current_pod_leader
    @callees = Callee.where(pod_id: @pod.id).filter { |c| !c.inactive }
  end

  def status
    @callee&.status_change_notes = nil

    render "pl/callees/edit/status"
  end

  def save_status
    @callee.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @callee.save
      RoleStatusChange.create(callee: @callee, status: @callee.status, notes: @callee.status_change_notes, created_by: current_user, datetime: @status_change_datetime)

      SearchCacheRefresh.perform_async
      redirect_to pl_person_path(@current_pod_leader, @callee.person), notice: "Caller status was successfully updated."
    else
      render "pl/callees/edit/status"
    end
  end

  private

  def set_callee_and_person
    @callee = Callee.find(params[:id])
    @person = @callee.person

    redirect_to "/invalid_permissions_for_page" if @callee.pod != current_pod_leader.pod
  end

  def status_params
    params.require(:callee).permit(:id, :status, :status_change_notes)
  end
end

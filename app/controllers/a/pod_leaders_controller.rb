class A::PodLeadersController < A::AController
  before_action :set_pod_leader_and_person, only: %i[status save_status]

  def index
    @pod_leaders = PodLeader.all
  end

  def status
    @pod_leader&.status_change_notes = nil

    render "a/pod_leaders/edit/status"
  end

  def save_status
    @pod_leader.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @pod_leader.save
      RoleStatusChange.create(pod_leader: @pod_leader, status: @pod_leader.status, notes: @pod_leader.status_change_notes, created_by: current_user, datetime: @pod_leader.status_change_datetime)

      SearchCacheRefresh.perform_async
      redirect_to status_a_edit_pod_leader_path(@pod_leader), notice: "Pod leader status was successfully updated."
    else
      render "a/pod_leaders/edit/status"
    end
  end

  private

  def set_pod_leader_and_person
    @pod_leader = PodLeader.find(params[:id])
    @person = @pod_leader.person
  end

  def status_params
    params.require(:pod_leader).permit(:id, :status, :status_change_notes)
  end
end

class Pl::CalleesController < Pl::PlController
  before_action :set_callee, only: %i[status update emergency_contacts details]

  def index
    @pod = @fetcher.pod(params[:id])
    @callees = @pod.callees.filter { |m| m.status != :left_programme }
  end

  def status
    @callee&.status_change_notes = nil

    render "pl/callees/edit/status"
  end

  def update
    @callee.assign_attributes(update_params.merge({ "status_change_datetime": DateTime.now }))

    if @callee.save
      RoleStatusChange.create(callee: @callee, status: @callee.status, notes: @callee.status_change_notes, created_by: @current_user, datetime: @callee.status_change_datetime)

      SearchCacheRefresh.perform_async
      redirect_to pl_person_path(@callee.person), notice: "Callee status was successfully updated."
    else
      render "pl/callees/edit/status"
    end
  end

  private

  def set_callee
    @callee = @fetcher.callee(params[:id])
    @person = @callee.person
    @pod = @callee.pod
  end

  def update_params
    params.require(:callee).permit(:id, :status, :status_change_notes)
  end
end

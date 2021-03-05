class A::CalleesController < A::AController
  before_action :set_callee_and_person, only: %i[status save_status]

  def status
    @callee&.status_change_notes = nil

    render "a/callees/edit/status"
  end

  def save_status
    @callee.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @callee.save
      RoleStatusChange.create(callee: @callee, status: @callee.status, notes: @callee.status_change_notes, created_by: current_user)

      SearchCacheRefresh.perform_async
      redirect_to status_a_edit_callee_path(@callee), notice: "Callee status was successfully updated."
    else
      render "a/callees/edit/status"
    end
  end

  private

  def set_callee_and_person
    @callee = Callee.find(params[:id])
    @person = @callee.person
  end

  def status_params
    params.require(:callee).permit(:id, :status, :status_change_notes)
  end
end

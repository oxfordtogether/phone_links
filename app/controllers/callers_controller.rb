class A::CallersController < A::AController
  before_action :set_caller_and_person, only: %i[status save_status]

  def status
    @caller&.status_change_notes = nil

    render "a/callers/edit/status"
  end

  def save_status
    @caller.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @caller.save
      RoleStatusChange.create(caller: @caller, status: @caller.status, notes: @caller.status_change_notes, created_by: current_user)

      SearchCacheRefresh.perform_async
      redirect_to status_a_edit_caller_path(@caller), notice: "Caller status was successfully updated."
    else
      render "a/callers/edit/status"
    end
  end

  private

  def set_caller_and_person
    @caller = Caller.find(params[:id])
    @person = @caller.person
  end

  def status_params
    params.require(:caller).permit(:id, :status, :status_change_notes)
  end
end

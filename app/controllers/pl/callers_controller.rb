class Pl::CallersController < Pl::PlController
  before_action :set_caller, only: %i[status update update_status details]

  def index
    @pod = @fetcher.pod(params[:id])
    @callers = @pod.callers
  end

  def interactions
    @pod = @fetcher.pod(params[:id])
    @callers = @pod.callers
  end

  def status
    @caller&.status_change_notes = nil

    render "pl/callers/edit/status"
  end

  def update
    @caller.assign_attributes(update_params)

    if @caller.save
      SearchCacheRefresh.perform_async
      redirect_to pl_person_path(@caller.person), notice: "Caller was successfully updated."
    else
      render "pl/callers/details"
    end
  end

  def update_status
    @caller.assign_attributes(update_status_params.merge({ "status_change_datetime": DateTime.now }))

    if @caller.save
      RoleStatusChange.create(caller: @caller, status: @caller.status, notes: @caller.status_change_notes, created_by: @current_user, datetime: @caller.status_change_datetime)

      SearchCacheRefresh.perform_async
      redirect_to pl_person_path(@caller.person), notice: "Caller status was successfully updated."
    else
      render "pl/callers/edit/status"
    end
  end

  private

  def set_caller
    @caller = @fetcher.caller(params[:id])
    @person = @caller.person
    @pod = @caller.pod
  end

  def update_status_params
    params.require(:caller).permit(:id, :status, :status_change_notes)
  end

  def update_params
    params.require(:caller).permit(:check_in_frequency)
  end
end

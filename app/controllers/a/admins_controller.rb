class A::AdminsController < A::AController
  before_action :set_admin_and_person, only: %i[status save_status]

  def index
    @admins = Admin.all
  end

  def status
    @admin&.status_change_notes = nil

    render "a/admins/edit/status"
  end

  def save_status
    @admin.assign_attributes(status_params.merge({ "status_change_datetime": DateTime.now }))

    if @admin.save
      RoleStatusChange.create(admin: @admin, status: @admin.status, notes: @admin.status_change_notes, created_by: @current_user, datetime: @admin.status_change_datetime)

      SearchCacheRefresh.perform_async
      redirect_to status_a_edit_admin_path(@admin), notice: "Admin status was successfully updated."
    else
      render "a/admins/edit/status"
    end
  end

  private

  def set_admin_and_person
    @admin = Admin.find(params[:id])
    @person = @admin.person
  end

  def status_params
    params.require(:admin).permit(:id, :status, :status_change_notes)
  end
end

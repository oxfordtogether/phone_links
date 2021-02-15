class A::AdminsController < ApplicationController
  before_action :set_admin, only: %i[]

  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new(person_id: params[:id])
    @redirect_on_cancel = params[:redirect_on_cancel] || a_person_path(@admin.person)
  end

  def create
    @redirect_on_cancel = admin_params[:redirect_on_cancel]
    @admin = Admin.new(admin_params.except(:redirect_on_cancel))

    if @admin.save
      SearchCacheRefresh.perform_async
      redirect_to a_person_path(@admin.person), notice: "Admin was successfully created."
    else
      @redirect_on_cancel || a_person_path(@admin.person)
      render :new
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:active, :person_id, :redirect_on_cancel)
  end
end

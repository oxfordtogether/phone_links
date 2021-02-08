class AdminsController < ApplicationController
  before_action :set_admin, only: %i[]

  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new(person_id: params[:id])
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to @admin.person, notice: "Admin was successfully created."
    else
      render :new
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:active, :person_id)
  end
end

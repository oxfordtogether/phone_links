class A::CalleesController < ApplicationController
  before_action :set_callee, only: %i[edit update]

  # GET people/:id/callee/new
  def new
    @callee = Callee.new(person_id: params[:id])
  end

  def create
    @callee = Callee.new(callee_params)

    if @callee.save
      SearchCacheRefresh.perform_async
      redirect_to a_person_path(@callee.person), notice: "Callee was successfully created."
    else
      render :new
    end
  end

  private

  def set_callee
    @callee = Callee.find(params[:id])
  end

  def callee_params
    params.require(:callee).permit(:person_id, :pod_id, :active, :reason_for_referral, :living_arrangements, :other_information, :additional_needs)
  end
end

class CalleesController < ApplicationController
  before_action :set_callee, only: %i[edit update]

  # GET people/:id/callee/new
  def new
    @callee = Callee.new(person_id: params[:id])
  end

  def create
    @callee = Caller.new(callee_params)

    if @callee.save
      redirect_to @callee.person, notice: "Callee was successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @callee.update(callee_params)
      redirect_to @callee.person, notice: "Caller was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_callee
    @callee = Callee.find(params[:id])
  end

  def callee_params
    params.require(:callee).permit(:person_id, :active, :reason_for_referral, :living_arrangements, :other_information, :additional_needs)
  end
end

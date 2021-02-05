class CallersController < ApplicationController
  before_action :set_caller, only: %i[edit update]

  # GET people/:id/caller/new
  def new
    @caller = Caller.new(person_id: params[:id])
  end

  def create
    @caller = Caller.new(caller_params)

    if @caller.save
      redirect_to @caller.person, notice: "Caller was successfully created."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @caller.update(caller_params)
      redirect_to @caller.person, notice: "Caller was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_caller
    @caller = Caller.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:title, :first_name, :last_name, :email, :phone)
  end

  def caller_params
    params.require(:caller).permit(:start_date, :end_date, :person_id, :active, :experience)
  end
end

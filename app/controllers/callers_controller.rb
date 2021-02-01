class CallersController < ApplicationController
  before_action :set_caller, only: %i[edit update]

  def new
    @caller = Caller.new
  end

  def edit; end

  def create
    @caller = Caller.new(caller_params)

    if @caller.save
      redirect_to @caller, notice: "Caller was successfully created."
    else
      render :new
    end
  end

  def update
    if @caller.update(caller_params)
      redirect_to @caller, notice: "Caller was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_caller
    @caller = Caller.find(params[:id])
  end

  def caller_params
    # where is person_id going to come from?
    params.require(:caller).permit(:start_date, :end_date)
  end
end

class A::CallersController < ApplicationController
  before_action :set_caller, only: %i[edit update]

  # GET people/:id/caller/new
  def new
    @caller = Caller.new(person_id: params[:id])
    @redirect_on_cancel = params[:redirect_on_cancel] || a_person_path(@caller.person)
  end

  def create
    @redirect_on_cancel = caller_params[:redirect_on_cancel]
    @caller = Caller.new(caller_params)

    if @caller.save
      SearchCacheRefresh.perform_async
      redirect_to a_person_path(@caller.person), notice: "Caller was successfully created."
    else
      @redirect_on_cancel ||= a_person_path(@caller.person)
      render :new
    end
  end

  def edit; end

  def update
    if @caller.update(caller_params)
      redirect_to a_person_path(@caller.person), notice: "Caller was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_caller
    @caller = Caller.find(params[:id])
  end

  def caller_params
    params.require(:caller).permit(:person_id, :pod_id, :active, :experience, :redirect_on_cancel)
  end
end

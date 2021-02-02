class PodsController < ApplicationController
  before_action :set_pod, only: %i[show edit update]

  def index
    @pods = Pod.all
  end

  def show
    @pod = Pod.with_matches.find(params[:id])
  end

  def new
    @pod = Pod.new
  end

  def edit; end

  def create
    @pod = Pod.new(pod_params)

    if @pod.save
      redirect_to @pod, notice: "Pod was successfully created."
    else
      render :new
    end
  end

  def update
    if @pod.update(pod_params)
      redirect_to @pod, notice: "Pod was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_pod
    @pod = Pod.find(params[:id])
  end

  def pod_params
    params.require(:pod).permit(:name, :pod_leader_id)
  end
end

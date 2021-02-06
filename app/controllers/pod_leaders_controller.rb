class PodLeadersController < ApplicationController
  before_action :set_pod_leader, only: %i[]

  def index
    @pod_leaders = PodLeader.all
  end

  def new
    @pod_leader = PodLeader.new(person_id: params[:id])
  end

  def create
    @pod_leader = PodLeader.new(pod_leader_params)

    if @pod_leader.save
      redirect_to @pod_leader, notice: "Pod Leader was successfully created."
    else
      render :new
    end
  end

  private

  def set_pod_leader
    @pod_leader = PodLeader.find(params[:id])
  end

  def pod_leader_params
    params.require(:pod_leader).permit(:active, :pod_id, :person_id)
  end
end

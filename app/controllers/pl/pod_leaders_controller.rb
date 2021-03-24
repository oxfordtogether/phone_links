class Pl::PodLeadersController < Pl::PlController
  # pl/pod_leaders/1
  def show
    @pod_leader = @fetcher.pod_leader(params[:id])

    redirect_to pl_pod_path(@pod_leader.pods[0]) if @pod_leader.pods.count == 1
  end
end

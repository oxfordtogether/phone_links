class Pl::PodLeadersController < Pl::PlController
  # pl/pod_leaders/1
  def show
    @pod_leader = @fetcher.pod_leader(params[:id])

    pods_that_supports = @pod_leader.pod_supporters.map(&:pod)
    pods = @pod_leader.pods

    @all_pods = pods_that_supports + pods

    redirect_to pl_pod_path(@all_pods[0]) if @all_pods.count == 1
  end
end

class Pl::MatchesController < Pl::PlController
  before_action :set_match, only: %i[show]

  def index
    @pod = current_pod_leader.pod
    @current_pod_leader = current_pod_leader
    @matches = Match.where(pod_id: @pod.id)
  end

  def show
    @current_pod_leader = current_pod_leader
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit
  end
end

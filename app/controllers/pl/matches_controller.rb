class Pl::MatchesController < Pl::PlController
  before_action :set_match, only: %i[show edit update]
  before_action :set_current_pod_leader, only: %i[index show new create edit update]

  def index
    @pod = current_pod_leader.pod
    @matches = Match.where(pod_id: @pod.id)
  end

  def show
    @events = (@match.match_status_changes + @match.reports).sort_by(&:created_at).reverse
  end

  def new
    @match = Match.new(start_date: Date.today, pod_id: @current_pod_leader.pod.id)
    @callees = current_pod_leader.pod.callees
    @callers = current_pod_leader.pod.callers
  end

  def create
    unless current_pod_leader.pod.id == new_match_params[:pod_id].to_i &&
           current_pod_leader.pod.callers.map(&:id).include?(new_match_params[:caller_id].to_i) &&
           current_pod_leader.pod.callees.map(&:id).include?(new_match_params[:callee_id].to_i)
      return redirect_to "/invalid_permissions_for_page"
    end

    @match = Match.new(new_match_params)
    if @match.save
      MatchStatusChange.create(match: @match, created_by: current_user, status: @match.status, notes: @match.status_change_notes)
      redirect_to pl_match_path(current_pod_leader, @match), notice: "Match was successfully created."
    else
      @callees = current_pod_leader.pod.callees
      @callers = current_pod_leader.pod.callers
      render :new
    end
  end

  def edit
    @match.status_change_notes = nil
  end

  def update
    unless current_pod_leader.pod.id == @match.pod.id &&
           current_pod_leader.pod.callers.map(&:id).include?(@match.caller.id) &&
           current_pod_leader.pod.callees.map(&:id).include?(@match.callee.id)
      return redirect_to "/invalid_permissions_for_page"
    end

    if @match.update(edit_match_params)
      MatchStatusChange.create(match: @match, created_by: current_user, status: @match.status, notes: @match.status_change_notes)
      redirect_to pl_match_path(current_pod_leader, @match), notice: "Match was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_current_pod_leader
    @current_pod_leader = current_pod_leader
  end

  def set_match
    @match = Match.find(params[:id])

    redirect_to "/invalid_permissions_for_page" if @match.pod != current_pod_leader.pod
  end

  def new_match_params
    params.require(:match).permit(:pod_id, :caller_id, :callee_id, :status, :status_change_notes)
  end

  def edit_match_params
    params.require(:match).permit(:status, :status_change_notes)
  end
end

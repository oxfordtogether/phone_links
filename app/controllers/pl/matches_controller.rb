class Pl::MatchesController < Pl::PlController
  before_action :set_match, only: %i[show edit update]
  before_action :set_current_pod_leader, only: %i[index show new create edit update]

  def index
    @pod = current_pod_leader.pod
    @matches = Match.where(pod_id: @pod.id)
  end

  def show; end

  def new
    @match = Match.new(start_date: Date.today, pod_id: @current_pod_leader.pod.id)
    @callees = current_pod_leader.pod.callees
    @callers = current_pod_leader.pod.callers
  end

  def create
    unless current_pod_leader.pod.id == new_match_params[:pod_id] &&
           current_pod_leader.pod.callers.include?(new_match_params[:caller_id]) &&
           current_pod_leader.pod.callees.include?(new_match_params[:callee_id])
      redirect_to "/invalid_permissions_for_page"
    end

    @match = Match.new(new_match_params)
    if @match.save
      @match.create_events!
      redirect_to pl_match_path(current_pod_leader, @match), notice: "Match was successfully created."
    else
      @callees = current_pod_leader.pod.callees
      @callers = current_pod_leader.pod.callers
      render :new
    end
  end

  def edit; end

  def update
    unless current_pod_leader.pod.id == @match.pod.id &&
           current_pod_leader.pod.callers.include?(@match.caller.id) &&
           current_pod_leader.pod.callees.include?(@match.callee.id)
      redirect_to "/invalid_permissions_for_page"
    end

    if @match.update(edit_match_params)
      @match.create_events!
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
    params.require(:match).permit(:pod_id, :pending, :start_date, :caller_id, :callee_id)
  end

  def edit_match_params
    params.require(:match).permit(:pending, :end_reason, :end_reason_notes, :start_date, :end_date)
  end
end

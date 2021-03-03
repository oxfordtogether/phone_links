class A::MatchesController < A::AController
  before_action :set_match, only: %i[show edit update destroy activate]

  def show
    @events = @match.match_status_changes
  end

  def new
    @pod_id ||= nil

    if @pod_id.present?
      @pod = Pod.find(@pod_id)
    elsif @pod_id == ""
      @pod = nil
    elsif params[:pod_id]
      @pod = Pod.find(params[:pod_id])
    end

    if @pod.present?
      @match = Match.new(pod_id: @pod.id)

      @callers = Caller.where(pod_id: @pod.id)
      @callees = Callee.where(pod_id: @pod.id)
    else
      @match = Match.new

      @callers = Caller.all
      @callees = Callee.all
    end

    @redirect_on_cancel = params["redirect_on_cancel"] || a_waitlist_provisional_matches_path
  end

  def create
    @redirect_on_cancel = new_provisional_match_params[:redirect_on_cancel]
    @match = Match.new(new_provisional_match_params.except(:redirect_on_cancel))

    if @match.save
      MatchStatusChange.create(match: @match, created_by: current_user, status: @match.status)
      redirect_to a_match_path(@match), notice: "Provisional match was successfully created."
    else
      @redirect_on_cancel ||= a_waitlist_provisional_matches_path
      render :new
    end
  end

  def edit; end

  def update
    if @match.update(match_params)
      MatchStatusChange.create(match: @match, created_by: current_user, status: @match.status)
      redirect_to a_match_path(@match), notice: "Match was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def new_provisional_match_params
    params.require(:match).permit(:pod_id, :caller_id, :callee_id, :status, :redirect_on_cancel)
  end

  def match_params
    params.require(:match).permit(:pod_id, :status, :end_reason, :end_reason_notes)
  end
end

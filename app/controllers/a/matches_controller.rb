class A::MatchesController < A::AController
  before_action :set_match, only: %i[show edit update destroy activate]

  def show
    @events = (@match.match_status_changes + @match.reports).sort_by(&:created_at).reverse
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
  end

  def create
    @match = Match.new(new_provisional_match_params.merge({ status_change_datetime: DateTime.now }))

    if @match.save
      MatchStatusChange.create(match: @match, created_by: @current_user, status: @match.status, notes: @match.status_change_notes, datetime: @match.status_change_datetime)
      redirect_to a_match_path(@match), notice: "Provisional match was successfully created."
    else
      @callers = Caller.all
      @callees = Callee.all

      render :new
    end
  end

  def edit
    @match.status_change_notes = nil
  end

  def update
    if @match.update(match_params.merge({ status_change_datetime: DateTime.now }))
      MatchStatusChange.create(match: @match, created_by: @current_user, status: @match.status, notes: @match.status_change_notes, datetime: @match.status_change_datetime)
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
    params.require(:match).permit(:pod_id, :caller_id, :callee_id, :status, :status_change_notes)
  end

  def match_params
    params.require(:match).permit(:pod_id, :status, :status_change_notes)
  end
end

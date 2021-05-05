class Pl::MatchesController < Pl::PlController
  before_action :set_match, only: %i[show edit update]

  def index
    @pod = @fetcher.pod(params[:id])
    @matches = @pod.matches
  end

  def show
    @events = (@match.match_status_changes + @match.reports).sort_by(&:created_at).reverse
    @pod = @match.pod
  end

  def new
    @pod = @fetcher.pod(params[:id])
    @match = Match.new(pod_id: @pod.id)

    @callees = @fetcher.callees(@pod.id)
    @callers = @fetcher.callers(@pod.id)
  end

  def create
    @pod = @fetcher.pod(new_match_params[:pod_id])
    @fetcher.callee(new_match_params[:callee_id])
    @fetcher.caller(new_match_params[:caller_id])

    @match = Match.new(new_match_params)
    if @match.save
      redirect_to pl_match_path(@match), notice: "Match was successfully created."
    else
      @callees = @fetcher.callees(@match.pod_id)
      @callers = @fetcher.callers(@match.pod_id)
      render :new
    end
  end

  def edit
    @match.status_change_notes = nil

    redirect_to edit_pl_match_path(@match, :status) unless params[:page]
  end

  def update
    @pod = @fetcher.pod(@match.pod_id)
    @fetcher.callee(@match.callee_id)
    @fetcher.caller(@match.caller_id)

    if @match.update(edit_match_params)
      redirect_to pl_match_path(@match), notice: "Match was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_match
    @match = @fetcher.match(params[:id])
    @pod = @match.pod
  end

  def new_match_params
    params.require(:match).permit(:pod_id, :caller_id, :callee_id, :status, :status_change_notes)
  end

  def edit_match_params
    params.require(:match).permit(:status, :status_change_notes, :report_frequency, :alerts_paused_until)
  end
end

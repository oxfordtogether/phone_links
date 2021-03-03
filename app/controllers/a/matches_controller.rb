class A::MatchesController < A::AController
  before_action :set_match, only: %i[show edit update destroy activate]

  def show; end

  def new
    pod_id = params[:pod_id]
    @match = Match.new(pod_id: pod_id)
    @redirect_on_cancel = params["redirect_on_cancel"] || a_waitlist_provisional_matches_path
  end

  def create
    @redirect_on_cancel = new_provisional_match_params[:redirect_on_cancel]
    @match = Match.new(new_provisional_match_params.except(:redirect_on_cancel))

    if @match.save
      @match.create_events!
      redirect_to a_match_path(@match), notice: "Provisional match was successfully created."
    else
      @redirect_on_cancel ||= a_waitlist_provisional_matches_path
      render :new
    end
  end

  def edit; end

  def activate
    activate_match_params_hash = activate_match_params
    activate_match_params_hash["start_date"] = Date.today

    if @match.update(activate_match_params_hash)
      @match.create_events!
      redirect_to a_match_path(@match), notice: "Match was successfully activated."
    else
      render :edit
    end
  end

  def update
    if @match.update(match_params)
      @match.create_events!
      redirect_to a_match_path(@match), notice: "Match was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @match.update(deleted_at: Time.now)

    redirect_to a_pod_path(@match.pod), notice: "Match was successfully deleted."
  end

  private

  def set_match
    @match = Match.find(params[:id])
  end

  def new_provisional_match_params
    params.require(:match).permit(:pod_id, :caller_id, :callee_id, :redirect_on_cancel)
  end

  def delete_provisional_match_params
    params.require(:match).permit(:id)
  end

  def activate_match_params
    params.require(:match).permit(:id)
  end

  def match_params
    params.require(:match).permit(:pod_id, :end_reason, :end_reason_notes, :end_date)
  end
end
